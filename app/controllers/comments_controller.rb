class CommentsController < ApplicationController
  include Authenticate

  before_action :set_comment, only: %i[ show edit update destroy ]
  before_action only: [:destroy] do
    authenticate_admin_user_session!(@comment.session_id, @comment.user_id)
  end


  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @image = Image.find(params[:image_id])
    @comment = @image.comments.create(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @image, notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        @comment.errors.full_messages.each {|message| puts(message)}
        puts(session[:session_id].nil?)
        format.html { render 'images/show' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: "Comment was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      unless Rails.env.test?
        params.require(:comment).permit(:text, :username).merge({session_id: session[:session_id], user_id: current_user&.[](:id)}) #Add session ID and user ID to the Request 
      else
        # Since the session[]-object cant be changed during tests, allow the parameter to pass through
        params.require(:comment).permit(:text, :username, :session_id).merge({user_id: current_user&.[](:id)})

      end
    end
end
