class CreateJoinTableTagImage < ActiveRecord::Migration[6.1]
  def change
    create_join_table :tags, :images do |t|
      # t.index [:tag_id, :image_id]
      # t.index [:image_id, :tag_id]
    end
  end
end
