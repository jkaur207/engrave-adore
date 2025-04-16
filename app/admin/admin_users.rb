# app/admin/admin_users.rb
ActiveAdmin.register AdminUser do
  # Permit parameters
  permit_params :email, :password, :password_confirmation

  # Controller configuration
  controller do
    def scoped_collection
      super # No incorrect includes
    end
  end

  # Index page configuration
  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :updated_at
    actions
  end

  # Filters configuration
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :updated_at

  # Form configuration
  form do |f|
    f.inputs 'Admin Details' do
      f.input :email
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      else
        f.input :password, hint: "Leave blank if you don't want to change it"
        f.input :password_confirmation, hint: "Leave blank if you don't want to change it"
      end
    end
    f.actions
  end

  # Show page configuration
  show do
    attributes_table do
      row :email
      row :current_sign_in_at
      row :last_sign_in_at
      row :sign_in_count
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  # General configuration
  config.sort_order = 'id_desc'
  config.batch_actions = true
  config.filters = true

  # Ransack configuration (redundant but safe - primary config is in model)
  controller do
    def apply_filtering(chain)
      super(chain).distinct
    end
  end
end