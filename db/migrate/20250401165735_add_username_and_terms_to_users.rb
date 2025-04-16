class AddUsernameAndTermsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :username, :string
    add_column :users, :terms_and_conditions, :boolean
  end
end
