class CreateJoinTableCollectionTag < ActiveRecord::Migration[6.1]
  def change
    create_join_table :collections, :tags do |t|
      # t.index [:collection_id, :tag_id]
      # t.index [:tag_id, :collection_id]
    end
  end
end
