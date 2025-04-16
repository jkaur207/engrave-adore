class AddSalePriceToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :sale_price, :decimal
  end
end
