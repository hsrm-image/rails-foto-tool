class AddUserIdToComments < ActiveRecord::Migration[6.1]
  def change
    rename_column :comments, :user_id, :session_id
    add_reference :comments, :user, null: true, foreign_key: true
  end
end
