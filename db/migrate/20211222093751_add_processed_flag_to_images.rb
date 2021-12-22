class AddProcessedFlagToImages < ActiveRecord::Migration[6.1]
  def change
    add_column :images, :processed, :boolean, default: false
  end
end
