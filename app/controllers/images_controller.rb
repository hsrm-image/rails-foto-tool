class ImagesController < ApplicationController
  before_action :set_image, only: %i[ show edit update destroy analyse ]

  # GET /images or /images.json
  def index
    @images = Image.order(:created_at).page(params[:page])
  end

  # GET /images/1 or /images/1.json
  def show
    @rating = Rating.new
    @rating.rateable_type = "Image"
    @rating.rateable_id = @image.id
    @rating.session_id = session[:session_id]

    @image = Image.find(params[:id])
    @comment = @image.comments.new
  end

  # GET /images/new
  def new
    if current_user
      @image = Image.new
     else
      respond_to do |format|
        format.html { redirect_to images_url, notice: "You are not logged in" }
      end
    end
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images or /images.json
  def create
    @image = current_user.images.new(image_params)
     
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
        format.html { redirect_to @image, notice: "Image was successfully updated." }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1 or /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: "Image was successfully destroyed." }
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
      params.require(:image).permit(:title, :description, :image_file)
    end
end
