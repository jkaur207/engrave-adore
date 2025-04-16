class ProperDeviseSetup < ActiveRecord::Migration[7.2]
  def change
    # First remove any existing Devise columns if they exist
    reversible do |dir|
      dir.up do
        # Remove columns if they exist
        remove_column :users, :encrypted_password if column_exists?(:users, :encrypted_password)
        remove_column :users, :reset_password_token if column_exists?(:users, :reset_password_token)
        remove_column :users, :reset_password_sent_at if column_exists?(:users, :reset_password_sent_at)
        remove_column :users, :remember_created_at if column_exists?(:users, :remember_created_at)

        # Remove indexes if they exist
        remove_index :users, name: :index_users_on_reset_password_token if index_exists?(:users, :reset_password_token)
      end
    end

    # Add the columns properly
    change_table :users do |t|
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
    end

    # Add the indexes
    add_index :users, :reset_password_token, unique: true
  end
end