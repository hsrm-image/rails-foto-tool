class ImagesController < ApplicationController
	include Authenticate
	before_action :set_image, only: %i[show edit update destroy analyse]
	before_action :authenticate_user!,
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
					redirect_to images_url,
					            notice:
							t(
								'controllers.invisible',
								resource: t('images.resource_name'),
							)
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

		@image.owner_id = current_user.id
		@image.title =
			File.basename(
				image_params[:image_file].original_filename,
				File.extname(image_params[:image_file].original_filename),
			)[0..49]
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
					render json: @image.errors.full_messages.join(", ").to_json, status: :unprocessable_entity
				end
			end
		end
	end

	# PATCH/PUT /images/1 or /images/1.json
	def update
		error = '_error'
		error = '' if @image.update(image_params)
		respond_to do |format|
			format.js do
				render 'layouts/toast',
				       locals: {
						method: (error == '' ? 'success' : 'error'),
						message:
							t(
								'controllers.updated' + error,
								resource: @image.title,
							),
						title: '',
				       }
			end
		end
	end

	# DELETE /images/1 or /images/1.json
	def destroy
		error = '_error'
		error = '' if @image.destroy
		respond_to do |format|
			format.js do
				render 'layouts/toast',
				       locals: {
						method: (error == '' ? 'success' : 'error'),
						message:
							t(
								'controllers.destroyed' + error,
								resource: @image.title,
							),
						title: '',
				       }
			end
		end
	end

	private

	# Use callbacks to share common setup or constraints between actions.
	def set_image
		begin
			Image.find(params[:id])
		rescue StandardError
			respond_to do |format|
				format.html do
					redirect_back fallback_location: root_path,
					              notice: t('controllers.image_404')
				end
				format.js do
					render 'layouts/toast',
					       locals: {
							method: 'error',
							message: t('controllers.image_404'),
							title: '',
					       }
				end
			end
		else
			@image = Image.find(params[:id])
		end
	end

	# Only allow a list of trusted parameters through.
	def image_params
		params
			.require(:image)
			.permit(:title, :description, :image_file, :updated_at, :created_at)
	end
end
