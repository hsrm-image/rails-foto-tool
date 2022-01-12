class ImagesController < ApplicationController
	before_action :set_image, only: %i[show edit update destroy]

	# GET /images or /images.json
	def index
		@images = Image.all
	end

	# GET /images/1 or /images/1.json
	def show; end

	# GET /images/new
	def new
		if current_user
			@image = Image.new
		else
			respond_to do |format|
				format.html do
					redirect_to images_url, notice: 'You are not logged in'
				end
			end
		end
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
					            notice: 'Image was successfully created.'
				end
				format.json { render :show, status: :created, location: @image }
			else
				format.html { render :new, status: :unprocessable_entity }
				format.json do
					render json: @image.errors, status: :unprocessable_entity
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
			format.html { redirect_back(fallback_location: root_path) }
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
