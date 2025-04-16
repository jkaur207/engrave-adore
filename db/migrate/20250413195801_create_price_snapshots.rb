class CreatePriceSnapshots < ActiveRecord::Migration[7.2]
  def change
    create_table :price_snapshots do |t|
      t.integer :product_id
      t.decimal :price
      t.datetime :effective_date

      t.timestamps
    end
  end
end
