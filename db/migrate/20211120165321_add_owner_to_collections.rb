class AddOwnerToCollections < ActiveRecord::Migration[6.1]
  def change
    add_reference :collections,  :owner, foreign_key: { to_table: :users }
  end
end
