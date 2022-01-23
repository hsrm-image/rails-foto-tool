class AddImagesToCollection < ActiveRecord::Migration[6.1]
	def change
		add_reference :collections, :images, null: true, foreign_key: false
	end
end
