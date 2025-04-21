class AddPaymentFieldsToOrders < ActiveRecord::Migration[7.0]
  def change
    # Only add columns that don't exist
    add_column :orders, :stripe_payment_intent_id, :string unless column_exists?(:orders, :stripe_payment_intent_id)
    add_column :orders, :paid_at, :datetime unless column_exists?(:orders, :paid_at)

    # If payment_status exists but you need to modify it (e.g., change type or default)
    if column_exists?(:orders, :payment_status)
      change_column :orders, :payment_status, :string, default: 'unpaid'
    else
      add_column :orders, :payment_status, :string, default: 'unpaid'
    end
  end
end