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
		print params['img']
		@image = Image.find(params['img'])
		respond_to { |format| format.js {} }
	end
end
