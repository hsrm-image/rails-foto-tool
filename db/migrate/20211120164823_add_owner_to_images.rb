class AddOwnerToImages < ActiveRecord::Migration[6.1]
  def change
    add_reference :images, :owner, foreign_key: { to_table: :users }
  end
end
