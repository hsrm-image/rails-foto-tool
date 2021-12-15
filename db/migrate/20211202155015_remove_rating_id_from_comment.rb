class RemoveRatingIdFromComment < ActiveRecord::Migration[6.1]
  def change
    remove_column :comments, :rating_id, :integer
    add_column :comments, :user_id, :string, null: false
  end
end
