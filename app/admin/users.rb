ActiveAdmin.register User do
  # Permit the necessary parameters to be editable in the form
  permit_params :email, :username, :phone_number, :role, :address, :province_id  # Include province_id

  # Index page - List all users with address and province information
  index do
    selectable_column
    id_column
    column :username
    column :email
    column :phone_number
    column :role  # Use role instead of admin
    column :address  # Add address column
    column :province do |user|
      user.province.present? ? user.province.name : "No Province"  # Safely handle nil province
    end
    column :created_at
    actions
  end

  # Show page - Display user details, including address and province
  show do
    attributes_table do
      row :id
      row :username
      row :email
      row :phone_number
      row :role  # Use role instead of admin
      row :address  # Add address row
      row :province do |user|
        user.province.present? ? user.province.name : "No Province"  # Safely handle nil province
      end
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

  # Filters for search functionality
  filter :username
  filter :email
  filter :created_at
  filter :phone_number
  filter :role, as: :select, collection: User.roles.keys.map { |key| [key.humanize, key] }

  # Fix for filtering by province using the foreign key
  filter :province_id_eq, as: :select, collection: Province.all.pluck(:name, :id), label: "Province"
  # Form page - Allow admins to edit users' address and province
  form do |f|
    f.inputs do
      f.input :username
      f.input :email
      f.input :phone_number
      f.input :role  # Use role instead of admin
      f.input :address
      f.input :province_id, as: :select, collection: Province.all.map { |p| [p.name, p.id] }  # Use province_id for selection
    end
    f.actions
  end
end
