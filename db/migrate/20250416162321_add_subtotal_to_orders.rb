class AddSubtotalToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :subtotal, :decimal
  end
end
