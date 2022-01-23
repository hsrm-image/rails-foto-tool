class RenameImagesToHeaderImage < ActiveRecord::Migration[6.1]
	def change
		rename_column :collections, :images_id, :header_image
	end
end
