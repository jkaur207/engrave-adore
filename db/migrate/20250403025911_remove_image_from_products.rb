class RemoveImageFromProducts < ActiveRecord::Migration[7.2]
  def change
    remove_column :products, :image
  end
end