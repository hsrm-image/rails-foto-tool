class CollectionsController < ApplicationController
	include Authenticate
	before_action :authenticate_user!
	before_action :set_collection, only: %i[show edit update destroy]

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
							}
				end
			end
		end
	end

	# PATCH/PUT /collections/1 or /collections/1.json
	def update
		@collection.update(collection_params)
	end

	# DELETE /collections/1 or /collections/1.json
	def destroy
		@collection.destroy
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
