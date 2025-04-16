class AddPaymentStatusToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :payment_status, :string
  end
end
