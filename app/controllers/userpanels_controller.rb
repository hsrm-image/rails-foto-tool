class UserpanelsController < ApplicationController
	def index
		if current_user
			@image = Image.new
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
		@image = Image.new
		@images = Image.all
		respond_to { |format| format.js {} }
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
		attr.except!('file', 'id', 'owner_id')
	end
end
