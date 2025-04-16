class AddOrderStatusToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :order_status, :string
  end
end
