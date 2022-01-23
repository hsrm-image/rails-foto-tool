class CollectionsController < ApplicationController
	before_action :set_collection, only: %i[show edit update destroy]

	# GET /collections or /collections.json
	def index
		if current_user
			@collections = Collection.order(:created_at).page(params[:page])
		else
			@collections =
				Collection
					.where(processed: true)
					.order(:created_at)
					.page(params[:page])
		end
	end

	# GET /collections/1 or /collections/1.json
	def show; end

	# GET /collections/new
	def new
		@collection = Collection.new
	end

	# GET /collections/1/edit
	def edit; end

	# POST /collections or /collections.json
	def create
		if current_user
			puts(collection_params)
			@collection = Collection.new(collection_params)
			@collection.owner_id = current_user.id
			respond_to do |format|
				if @collection.save
					format.js do
						render 'layouts/toast',
						       locals: {
								method: 'success',
								message: 'Collection created',
								title: '',
								position: 'toast-bottom-center',
						       }
					end
				else
					format.js do
						render 'layouts/toast',
						       locals: {
								method: 'error',
								message: 'Collection could not be created',
								title: '',
								position: 'toast-bottom-center',
						       }
					end
				end
			end
		else

		end
	end

	# PATCH/PUT /collections/1 or /collections/1.json
	def update
		if current_user
			@collection.update(collection_params)
		else
			respond_to do |format|
				format.js do
					render 'layouts/toast',
					       locals: {
							method: 'error',
							message: 'Not Authenticated',
							title: '',
					       }
				end
			end
		end
	end

	# DELETE /collections/1 or /collections/1.json
	def destroy
		if current_user
			@collection.destroy
		else
			respond_to do |format|
				format.js do
					render 'layouts/toast',
					       locals: {
							method: 'error',
							message: 'Not Authenticated',
							title: '',
					       }
				end
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
		params.require(:collection).permit(:name)
	end
end
