class AddFileToImages < ActiveRecord::Migration[6.1]
  def change
    add_column :images, :file, :string
  end
end
