class AddDiscontinuedToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :discontinued, :boolean
  end
end
