class AddRatingToComments < ActiveRecord::Migration[6.1]
  def change
    add_reference :comments, :rating, null: true, foreign_key: true
  end
end
