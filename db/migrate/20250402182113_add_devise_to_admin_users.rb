class AddDeviseToAdminUsers < ActiveRecord::Migration[7.2]
  def self.up
    change_table :admin_users do |t|
      # Only add the email column if it doesn't already exist
      unless column_exists?(:admin_users, :email)
        t.string :email, null: false, default: ""
      end

      # Only add the encrypted_password column if it doesn't already exist
      unless column_exists?(:admin_users, :encrypted_password)
        t.string :encrypted_password, null: false, default: ""
      end

      # Only add the reset_password_token column if it doesn't already exist
      unless column_exists?(:admin_users, :reset_password_token)
        t.string :reset_password_token
      end

      # Only add the reset_password_sent_at column if it doesn't already exist
      unless column_exists?(:admin_users, :reset_password_sent_at)
        t.datetime :reset_password_sent_at
      end

      # Only add the remember_created_at column if it doesn't already exist
      unless column_exists?(:admin_users, :remember_created_at)
        t.datetime :remember_created_at
      end
    end

    add_index :admin_users, :email, unique: true unless index_exists?(:admin_users, :email)
    add_index :admin_users, :reset_password_token, unique: true unless index_exists?(:admin_users, :reset_password_token)
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
