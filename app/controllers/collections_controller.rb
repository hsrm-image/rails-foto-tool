class CollectionsController < ApplicationController
	include Authenticate
	before_action :authenticate_user!, only: %i[new edit create update destroy]
	before_action :set_collection, only: %i[show edit update destroy]

	# GET /collections or /collections.json
	def index
		@collections = Collection.order(:created_at).page(params[:page])
	end

	# GET /collections/1 or /collections/1.json
	def show
		if current_user
			@images = @collection.images.order(:created_at).page(params[:page])
		else
			@images =
				@collection
					.images
					.where(processed: true)
					.order(:created_at)
					.page(params[:page])
		end
	end

	# GET /collections/new
	def new
		@collection = Collection.new
	end

	# GET /collections/1/edit
	def edit; end

	# POST /collections or /collections.json
	def create
		@collection = Collection.new(collection_params)
		@collection.owner_id = current_user.id
		error = '_error'
		error = '' if @collection.save
		respond_to do |format|
			format.js do
				render 'layouts/toast',
				       locals: {
						method: (error == '' ? 'success' : 'error'),
						message:
							t(
								'controllers.created' + error,
								resource: @collection.name,
								message: @collection.errors.full_messages.join(",")
							),
						title: '',
				       }
			end
		end
	end

	# PATCH/PUT /collections/1 or /collections/1.json
	def update
		error = '_error'
		error = '' if @collection.update(collection_params)
		respond_to do |format|
			format.js do
				render 'layouts/toast',
				       locals: {
						method: (error == '' ? 'success' : 'error'),
						message:
							t(
								'controllers.updated' + error,
								resource: @collection.name,
							),
						title: '',
				       }
			end
		end
	end

	# DELETE /collections/1 or /collections/1.json
	def destroy
		error = '_error'
		error = '' if @collection.destroy
		respond_to do |format|
			format.js do
				render 'layouts/toast',
				       locals: {
						method: (error == '' ? 'success' : 'error'),
						message:
							t(
								'controllers.destroyed' + error,
								resource: @collection.name,
							),
						title: '',
				       }
			end
		end
	end

	private

	# Use callbacks to share common setup or constraints between actions.
	def set_collection
		@collection = Collection.find(params[:id])
	end

	# Only allow a list of trusted parameters through.
	def collection_params
		params.require(:collection).permit(:name, :page)
	end
end
