class UserpanelsController < ApplicationController
	protect_from_forgery except: %i[
			show_images
			show_collections
			add_image_to_collection
			remove_image_from_collection
	                     ]
	def index
		if current_user
			@image = Image.new
			@images = Image.all
		else
			respond_to do |format|
				format.html do
					redirect_back(
						fallback_location: root_path,
						notice: 'You are not logged in',
					)
				end
			end
		end
	end
	def show_images
		if current_user
			@image = Image.new
			@images = Image.all
			respond_to do |format|
				puts format
				format.js {}
			end
		else
			respond_to do |format|
				format.html do
					redirect_back(
						fallback_location: root_path,
						notice: 'You are not logged in',
					)
				end
			end
		end
	end
	def show_collections
		if current_user
			@collections = Collection.all
			respond_to { |format| format.js {} }
		else
			respond_to do |format|
				format.html do
					redirect_back(
						fallback_location: root_path,
						notice: 'You are not logged in',
					)
				end
			end
		end
	end

	def create_collection
		if current_user
			respond_to do |format|
				format.js { render 'userpanels/show_collection_modal' }
			end
		else
			respond_to do |format|
				format.html do
					redirect_back(
						fallback_location: root_path,
						notice: 'You are not logged in',
					)
				end
			end
		end
	end
	def show_details
		if current_user
			@image = Image.find(params['img'])
			@informations = image_informations_filter(@image.attributes)
			@editables = image_editables_filter(@image.attributes)
			@collections = Collection.all
			puts @image.inspect
			respond_to { |format| format.js {} }
		else
			respond_to do |format|
				format.html do
					redirect_back(
						fallback_location: root_path,
						notice: 'You are not logged in',
					)
				end
			end
		end
	end
	def add_image_to_collection
		if current_user
			@image = Image.find(params[:image_id])
			@collection = Collection.find(params[:collection_id])
			return nil if @collection.images.include? @image
			@image.collections << @collection
			puts @image.collections.name
		else
			respond_to do |format|
				format.html do
					redirect_back(
						fallback_location: root_path,
						notice: 'You are not logged in',
					)
				end
			end
		end
	end

	#POST userpanel/join_collection_image
	# data: image_id, collection_id
	def remove_image_from_collection
		if current_user
			@image = Image.find(params[:image_id])
			@collection = Collection.find(params[:collection_id])
			return nil if !@collection.images.include? @image
			@image.collections.delete(@collection)
			puts @image.collections.name
		else
			respond_to do |format|
				format.html do
					redirect_back(
						fallback_location: root_path,
						notice: 'You are not logged in',
					)
				end
			end
		end
	end

	def show_collection_details
		if current_user
			@collection = Collection.find(params[:collection_id])
			@editables = collections_editables_filter(@collection.attributes)
		else
			respond_to do |format|
				format.html do
					redirect_back(
						fallback_location: root_path,
						notice: 'You are not logged in',
					)
				end
			end
		end
	end
	def image_informations_filter(attr)
		puts attr
		attr.extract!(
			'exif_camera_maker',
			'exif_camera_model',
			'exif_lens_model',
			'exif_focal_length',
			'exif_aperture',
			'exif_exposure',
			'exif_iso',
			'exif_gps_latitude',
			'exif_gps_longitude',
		)
	end
	def image_editables_filter(attr)
		puts attr
		attr.extract!('title', 'description')
	end
	def collections_informations_filter(attr)
		puts attr
		attr.extract!('na', 'description')
	end
	def collections_editables_filter(attr)
		puts attr
		attr.extract!('name')
	end
end
