class CreateJoinTableProductsOrders < ActiveRecord::Migration[7.2]
  def change
    create_join_table :products, :orders do |t|
      # t.index [:product_id, :order_id]
      # t.index [:order_id, :product_id]
    end
  end
end
