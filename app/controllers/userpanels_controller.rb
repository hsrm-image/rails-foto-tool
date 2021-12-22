class UserpanelsController < ApplicationController
	def index; end
	def show_images
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
