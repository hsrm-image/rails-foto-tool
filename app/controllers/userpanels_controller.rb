class UserpanelsController < ApplicationController
	include Authenticate
	before_action :authenticate_user!

	def index
		@image = Image.new
		@images = Image.all
	end

	def show_images
		@image = Image.new
		@images = Image.all
		respond_to { |format| format.js {} }
	end

	def startProccess
		image = Image.find(params[:image_id])
		if AnalyseImageJob.perform_now image
			respond_to do |format|
				format.js do
					render 'layouts/toast',
					       locals: {
							method: 'success',
							message: t('controllers.start_analyze'),
							title: '',
					       }
				end
			end
		end
	end

	def show_collections
		@collections = Collection.all
		respond_to { |format| format.js {} }
	end

	def create_collection
		respond_to do |format|
			format.js { render 'userpanels/show_collection_modal' }
		end
	end

	def show_details
		@image = Image.find(params['img'])
		@informations = image_informations_filter(@image.attributes)
		@editables = image_editables_filter(@image.attributes)
		@collections = Collection.all
		respond_to { |format| format.js {} }
	end

	def add_image_to_collection
		@image = Image.find(params[:image_id])
		@collection = Collection.find(params[:collection_id])
		return nil if @collection.images.include? @image
		error = '_error'
		error = '' if @image.collections << @collection
		respond_to do |format|
			format.js do
				render 'layouts/toast',
				       locals: {
						method: (error == '' ? 'success' : 'error'),
						message:
							t(
								'controllers.image_add_collection' + error,
								img: @image.title,
								col: @collection.name,
							),
						title: '',
				       }
			end
		end
	end

	#POST userpanel/join_collection_image
	# data: image_id, collection_id
	def remove_image_from_collection
		@image = Image.find(params[:image_id])
		@collection = Collection.find(params[:collection_id])
		return nil if !@collection.images.include? @image
		error = '_error'
		error = '' if @image.collections.delete(@collection)
		respond_to do |format|
			format.js do
				render 'layouts/toast',
				       locals: {
						method: 'success',
						message:
							t(
								'controllers.image_rem_collection' + error,
								img: @image.title,
								col: @collection.name,
							),
						title: '',
				       }
			end
		end
	end

	def set_collection_header
		@collection = Collection.find(params[:collection_id])
		error = '_error'
		setState = ''
		if params[:image_id] === ''
			setState = 'rem_'
			error = '' if @collection.update({ header_image: nil })
		else
			setState = 'set_'
			@img = Image.find(params[:image_id])
			error = '' if @collection.update({ header_image: @img })
		end

		respond_to do |format|
			format.js do
				render 'layouts/toast',
				       locals: {
						method: (error == '' ? 'success' : 'error'),
						message:
							t(
								'controllers.' + setState +
									'collection_header' + error,
								img: (@img != nil ? @img.title : nil),
								col: @collection.name,
							),
						title: '',
				       }
			end
		end
	end

	def show_collection_details
		@collection = Collection.find(params[:collection_id])
		@editables = collections_editables_filter(@collection.attributes)
	end
	def image_informations_filter(attr)
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
		attr.extract!('title', 'description')
	end
	def collections_informations_filter(attr)
		attr.extract!('na', 'description')
	end
	def collections_editables_filter(attr)
		attr.extract!('name')
	end
end
