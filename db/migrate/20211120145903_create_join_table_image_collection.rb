class CreateJoinTableImageCollection < ActiveRecord::Migration[6.1]
  def change
    create_join_table :collections, :images do |t|
      # t.index [:collection_id, :image_id]
      # t.index [:image_id, :collection_id]
    end
  end
end
