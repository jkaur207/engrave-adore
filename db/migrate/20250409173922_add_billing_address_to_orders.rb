class AddBillingAddressToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :billing_address, :string
  end
end
