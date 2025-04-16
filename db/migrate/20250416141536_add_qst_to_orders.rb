class AddQstToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :qst, :decimal
  end
end
