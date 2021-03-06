class CommentsController < ApplicationController
	include Authenticate
	before_action :set_comment, only: %i[show edit update destroy]
	before_action only: [:destroy] do
		authenticate_admin_user_session!(@comment.session_id, @comment.user_id)
	end

	# GET /comments or /comments.json
	def index
		@comments = Comment.all
	end

	# GET /comments/1 or /comments/1.json
	def show; end

	# GET /comments/new
	def new
		@comment = Comment.new
	end

	# GET /comments/1/edit
	def edit; end

	# POST /comments or /comments.json
	def create
		@image = Image.find(params[:image_id])
		@comment = @image.comments.new(comment_params)

		respond_to do |format|
			if @comment.save
				format.html { redirect_to @image, notice: t('.created') }
				format.json do
					render :show, status: :created, location: @comment
				end
				flash[:success] = t('.created')
				format.js do
					render 'comments/new',
					       locals: {
							nr_comments: @image.comments.count,
					       }
				end
			else
				format.html do
					redirect_to @image, status: :unprocessable_entity
				end
				format.json do
					render json: @comment.errors, status: :unprocessable_entity
				end
				format.js { render 'comments/new' }
			end
		end
	end

	# PATCH/PUT /comments/1 or /comments/1.json
	def update
		respond_to do |format|
			if @comment.update(comment_params)
				format.html do
					redirect_to @comment,
					            notice: t('controllers.updated', resource: t("comments.resource_name"))
				end
				format.json { render :show, status: :ok, location: @comment }
			else
				format.html { render :edit, status: :unprocessable_entity }
				format.json do
					render json: @comment.errors, status: :unprocessable_entity
				end
			end
		end
	end

	# DELETE /comments/1 or /comments/1.json
	def destroy
		@comment.destroy
		respond_to do |format|
			format.html do
				redirect_to @comment.image,
				            notice: t('controllers.destroyed', resource: t("comments.resource_name"))
			end
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
		params
			.require(:comment)
			.permit(:text, :username)
			.merge(
				{
					session_id: session[:session_id],
					user_id: current_user&.[](:id),
				},
			) #Add session ID and user ID to the Request
	end
end
