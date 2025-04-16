class CreateCheckouts < ActiveRecord::Migration[7.2]
  def change
    create_table :checkouts do |t|
      t.string :name
      t.text :billing_address
      t.text :address
      t.string :payment_info

      t.timestamps
    end
  end
end
