ActiveAdmin.register User do
  permit_params :email, :username, :phone_number, :role  # Use role instead of admin

  index do
    selectable_column
    id_column
    column :username
    column :email
    column :phone_number
    column :role  # Use role instead of admin
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :username
      row :email
      row :phone_number
      row :role  # Use role instead of admin
      row :created_at
      row :updated_at
    end

    panel "Orders by this User" do
      table_for user.orders do
        column :id
        column :status
        column :total
        column :created_at
        column "View" do |order|
          link_to "View Order", admin_order_path(order)
        end
      end
    end
  end

  filter :username
  filter :email
  filter :created_at
  filter :phone_number

  # Updated filter for 'role' to work with enum
  filter :role, as: :select, collection: User.roles.keys.map { |key| [key.humanize, key] }
end
