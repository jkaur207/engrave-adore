class AddDefaultRoleToUsers < ActiveRecord::Migration[7.0]
  def up
    # Set the default value for the role column to 'customer'
    change_column_default :users, :role, 'customer'

    # Update existing records where role is nil
    User.where(role: nil).update_all(role: 'customer')
  end

  def down
    # Revert the default value change
    change_column_default :users, :role, nil
  end
end
