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
			@collection = Collection.find(params[:collection_id]) unless params[:collection_id].nil?
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
		if current_user
			@image = Image.new
		else
			respond_to do |format|
				format.js do
					render 'layouts/toast',
					       locals: {
							method: 'error',
							message:
								'Now re-analysing exif-data in Background. Please refresh this page in a few Seconds.',
							title: '',
					       }
				end
			end
		end

	end

	# GET /images/1/edit
	def edit; end

	# POST /images or /images.json
	def create
		@image = Image.new(image_params)

		@image.owner_id = current_user.id
		@image.title =
			File.basename(
				image_params[:image_file].original_filename,
				File.extname(image_params[:image_file].original_filename),
			)
		@image.description = ''


		respond_to do |format|
			if @image.save
				format.html do
					redirect_to @image,
					            notice: 'Image was successfully created.'
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
					            notice: 'Image will be analysed in background.'
				end
				format.js do
					render 'layouts/toast',
					       locals: {
							method: 'success',
							message:
								'Now re-analysing exif-data in Background. Please refresh this page in a few Seconds.',
							title: '',
					       }
				end
			else
				format.html { redirect_to @image, notice: 'No image!' }
				format.js do
					render 'layouts/toast',
					       locals: {
							method: 'error',
							message: 'Error: No image attached!',
							title: '',
					       }
				end
			end
		end
	end

	# PATCH/PUT /images/1 or /images/1.json
	def update
		if current_user
			@image.update(image_params)
		else
			respond_to do |format|
				format.js do
					render 'layouts/toast',
					       locals: {
							method: 'error',
							message: 'Error while updating',
							title: '',
					       }
				end
			end
		end
	end

	# DELETE /images/1 or /images/1.json
	def destroy
		if @image.destroy
			respond_to do |format|
				format.js do
					render 'layouts/toast',
					       locals: {
							method: 'success',
							message: 'Successfully deleted ' + @image.title,
							title: '',
					       }
				end
			end
		else
			respond_to do |format|
				format.js do
					render 'layouts/toast',
					       locals: {
							method: 'error',
							message: 'Error whilst deleting ' + @image.title,
							title: '',
					       }
				end
			end
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
