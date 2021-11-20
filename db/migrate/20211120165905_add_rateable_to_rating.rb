class AddRateableToRating < ActiveRecord::Migration[6.1]
  def change
    add_reference :ratings, :rateable, polymorphic: true, null: false
  end
end
