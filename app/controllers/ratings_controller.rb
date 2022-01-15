class RatingsController < ApplicationController
  before_action :set_rating, only: %i[ show edit update destroy ]

  # GET /ratings or /ratings.json
  def index
    @ratings = Rating.all
  end

  # GET /ratings/1 or /ratings/1.json
  def show
  end

  # GET /ratings/new
  def new
    @rating = Rating.new
  end

  # GET /ratings/1/edit
  def edit
  end

  # POST /ratings or /ratings.json
  def create
    # @rating = Rating.new(rating_params)
    @rating = Rating.find_or_create_by(:rateable_type => rating_params[:rateable_type], :rateable_id => rating_params[:rateable_id], :session_id => rating_params[:session_id])
    @rating.rating = rating_params[:rating]

    respond_to do |format|
      if @rating.save
        #format.html { redirect_back fallback_location: root_path, notice: "Rating was successfully created." }
        format.json { render json: {rating: @rating.rateable.get_score, nr_ratings: @rating.rateable.get_ratings.count} }
        format.js
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ratings/1 or /ratings/1.json
  def update
    respond_to do |format|
      if @rating.update(rating_params)
        format.html { redirect_to @rating, notice: t('controllers.updated', resource: t("ratings.resource_name")) }
        format.json { render :show, status: :ok, location: @rating }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ratings/1 or /ratings/1.json
  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to ratings_url, notice: t('controllers.destroyed', resource: t("ratings.resource_name")) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rating_params
      params.require(:rating).permit(:rating, :rateable_type, :rateable_id).merge({session_id: session[:session_id]})
    end
end
