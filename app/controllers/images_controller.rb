class ImagesController < ApplicationController
	before_action :set_image, only: %i[show edit update destroy]

  # GET /images or /images.json
  def index
    if current_user
      @images = Image.order(:created_at).page(params[:page]) 
    else
      @images = Image.where(:processed => true).order(:created_at).page(params[:page]) 
    end
  end

  # GET /images/1 or /images/1.json
  def show
    if current_user or Image.find(params[:id]).processed
      @image = Image.find(params[:id])
      @comment = @image.comments.new
     else
      respond_to do |format|
        format.html { redirect_to images_url, notice: "This image is not visible" }
      end
    end
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images or /images.json
  def create
		@image = Image.new(image_params)
		@image.owner = current_user
		@image.title = image_params[:image_file].original_filename
     
    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: "Image was successfully created." }
        format.json { render :show, status: :created, location: @image }
        AnalyseImageJob.perform_later @image 
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end


  def analyse
    respond_to do |format|
      if @image.image_file.attached?
        AnalyseImageJob.perform_later @image
        format.html { redirect_to @image, notice: "Image will be analysed in background." }
        format.js {render 'layouts/toast', locals: { :method => "success", :message => "Now re-analysing exif-data in Background. Please refresh this page in a few Seconds.", :title => ""}}
      else
        format.html { redirect_to @image, notice: "No image!" }
        format.js {render 'layouts/toast', locals: { :method => "error", :message => "Error: No image attached!", :title => ""}}
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
