class AddOrderIdToPriceSnapshots < ActiveRecord::Migration[7.2]
  def change
    add_reference :price_snapshots, :order, null: false, foreign_key: true
  end
end
