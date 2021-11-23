class AddRateableToRating < ActiveRecord::Migration[6.1]
  def change
    add_reference :ratings, :rateable, polymorphic: true, null: false
    add_index :ratings, [:user_id, :rateable_type, :rateable_id], unique: true, name: "index_user_on_rateable"
  end
end
