class CollectionsController < ApplicationController
	before_action :set_collection, only: %i[show edit update destroy]
	protect_from_forgery except: %i[create]

	# GET /collections or /collections.json
	def index
		@collections = Collection.all
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
		respond_to do |format|
			if @collection.update(collection_params)
				format.html do
					redirect_to @collection,
					            notice: 'Collection was successfully updated.'
				end
				format.json { render :show, status: :ok, location: @collection }
			else
				format.html { render :edit, status: :unprocessable_entity }
				format.json do
					render json: @collection.errors,
					       status: :unprocessable_entity
				end
			end
		end
	end

	# DELETE /collections/1 or /collections/1.json
	def destroy
		@collection.destroy
		respond_to do |format|
			format.html do
				redirect_to collections_url,
				            notice: 'Collection was successfully destroyed.'
			end
			format.json { head :no_content }
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
