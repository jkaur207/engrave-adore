class AddFieldsToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :name_on_card, :string
    #add_column :orders, :billing_address, :text
    add_column :orders, :delivery_address, :text
    add_column :orders, :phone_number, :string
    add_column :orders, :email, :string
    add_column :orders, :payment_method, :string
  end
end
