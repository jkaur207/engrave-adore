class AddPriceSnapshotToOrderItems < ActiveRecord::Migration[7.2]
  def change
    add_column :order_items, :price_snapshot_id, :integer
  end
end
