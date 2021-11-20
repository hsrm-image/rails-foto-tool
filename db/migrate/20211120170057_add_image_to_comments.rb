class AddImageToComments < ActiveRecord::Migration[6.1]
  def change
    add_reference :comments, :image, null: false, foreign_key: true
  end
end
