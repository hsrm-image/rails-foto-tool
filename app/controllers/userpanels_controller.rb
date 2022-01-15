class UserpanelsController < ApplicationController
	protect_from_forgery except: %i[show_images show_collections]
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
		respond_to { |format| format.js {} }
	end
	def show_details
		@image = Image.find(params['img'])
		@details = details_filter(@image.attributes)
		puts @details.class

		respond_to { |format| format.js {} }
	end
	def details_filter(attr)
		attr.except!(
			'file',
			'id',
			'owner_id',
			'created_at',
			'updated_at',
			'processed',
		)
	end
end
