class RenameUserIdToSessionId < ActiveRecord::Migration[6.1]
  def change
    rename_column :ratings, :user_id, :session_id
  end
end
