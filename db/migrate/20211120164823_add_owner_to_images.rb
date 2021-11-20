class AddOwnerToImages < ActiveRecord::Migration[6.1]
  def change
    add_reference :images, :owner, references: :user, null: false, foreign_key: true
  end
end
