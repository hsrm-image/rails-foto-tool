class ImagesController < ApplicationController
	include Authenticate
	before_action :set_image, only: %i[show edit update destroy analyse]
	before_action :authenticate_user_custom!,
	              only: %i[edit update destroy analyse new create]

	# GET /images or /images.json
	def index
		if current_user
			@images = Image.order(:created_at).page(params[:page])
		else
			@images =
				Image
					.where(processed: true)
					.order(:created_at)
					.page(params[:page])
		end
	end

	# GET /images/1 or /images/1.json
	def show
		if current_user or Image.find(params[:id]).processed
			@image = Image.find(params[:id])
			@comment = @image.comments.new
		else
			respond_to do |format|
				format.html do
					redirect_to images_url, notice: t("controllers.invisible", resource: t("images.resource_name"))
				end
			end
		end
	end

	# GET /images/new
	def new
		@image = Image.new
	end

	# GET /images/1/edit
	def edit; end

	# POST /images or /images.json
	def create
		@image = Image.new(image_params)
		@image.owner = current_user
		@image.title = image_params[:image_file].original_filename

		respond_to do |format|
			if @image.save
				format.html do
					redirect_to @image,
					            notice: t('controllers.created', resource: t("images.resource_name"))
				end
				format.json { render :show, status: :created, location: @image }
				AnalyseImageJob.perform_later @image
			else
				format.html { render :new, status: :unprocessable_entity }
				format.json do
					render json: @image.errors, status: :unprocessable_entity
				end
			end
		end
	end

	def analyse
		respond_to do |format|
			if @image.image_file.attached?
				AnalyseImageJob.perform_later @image
				format.html do
					redirect_to @image,
					            notice: t('.analysing')
				end
				format.js do
					render 'layouts/toast',
					       locals: {
							method: 'success',
							message:
								t('.analysing'),
							title: '',
					       }
				end
			else
				format.html { redirect_to @image, notice: t('controllers.no_attached', resource: t("images.resource_name")) }
				format.js do
					render 'layouts/toast',
					       locals: {
							method: 'error',
							message: t('controllers.no_attached', resource: t("images.resource_name")),
							title: '',
					       }
				end
			end
		end
	end

	# PATCH/PUT /images/1 or /images/1.json
	def update
		respond_to do |format|
			if @image.update(image_params)
				format.html { redirect_to userpanels_path, format: 'js' }
			end
		end
	end

	# DELETE /images/1 or /images/1.json
	def destroy
		@image.destroy
		respond_to do |format|
			format.html { redirect_to images_path, notice: t("controllers.destroyed", resource: t("images.resource_name")) }
			format.json { head :no_content }
		end
	end

	private

	# Use callbacks to share common setup or constraints between actions.
	def set_image
		@image = Image.find(params[:id])
	end

	# Only allow a list of trusted parameters through.
	def image_params
		params
			.require(:image)
			.permit(:title, :description, :image_file, :updated_at, :created_at)
	end
end
