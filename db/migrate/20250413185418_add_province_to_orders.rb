class AddProvinceToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :province, :string
  end
end
