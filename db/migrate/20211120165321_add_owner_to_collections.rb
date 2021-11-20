class AddOwnerToCollections < ActiveRecord::Migration[6.1]
  def change
    add_reference :collections,  :owner, references: :user, null: false, foreign_key: true
  end
end
