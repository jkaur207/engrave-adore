ActiveAdmin.register Order do
  # Permit the necessary parameters
  permit_params :user_id, :order_number, :order_status, :payment_status, :subtotal,
                :tax_amount, :payment_method, :paid_at,
                :gst, :pst, :hst,
                order_items_attributes: [:id, :product_id, :quantity, :price, :_destroy]

  # Index page configuration
  index do
    selectable_column
    id_column
    column :order_number
    column :user
    column :order_status
    column :payment_status
    column :total do |order|
      number_to_currency(order.total)  # Format total as currency
    end
    column :created_at
    actions
  end

  # Show page configuration
  show do
    attributes_table do
      row :order_number
      row :user
      row :order_status
      row :payment_status
      row :subtotal
      row :tax_amount
      row :total do |order|
        number_to_currency(order.total)  # Format total as currency
      end
      row :payment_method
      row :paid_at
      row :gst
      row :pst
      row :hst
      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product
        column :quantity
        column :price
        column("Total Price") { |item| number_to_currency(item.quantity * item.price) }
      end
    end
  end

  # Form page configuration
  form do |f|
    f.semantic_errors

    f.inputs 'Order Details' do
      f.input :user
      f.input :order_number
      f.input :order_status, as: :select, collection: Order.order_statuses.keys
      f.input :payment_status, as: :select, collection: Order.payment_statuses.keys
      f.input :subtotal
      f.input :tax_amount
      f.input :payment_method
      f.input :paid_at, as: :datetime_picker
      f.input :gst
      f.input :pst
      f.input :hst
    end

    f.inputs 'Order Items' do
      f.has_many :order_items, allow_destroy: true, new_record: true do |oi|
        oi.input :product
        oi.input :quantity
        oi.input :price, min: 0.01  # Fix: Avoid Formtastic error by setting min explicitly
      end
    end

    f.actions
  end

  # Filters
  filter :order_number
  filter :user
  filter :order_status, as: :select, collection: Order.order_statuses.keys
  filter :payment_status, as: :select, collection: Order.payment_statuses.keys
  filter :created_at
end
