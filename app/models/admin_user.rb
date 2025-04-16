class AdminUser < ApplicationRecord
       # Include default devise modules
       devise :database_authenticatable,
              :recoverable, :rememberable, :validatable

       # Ransack configuration for ActiveAdmin
       def self.ransackable_attributes(auth_object = nil)
         # Whitelist only safe, non-sensitive attributes for searching
         %w[id email created_at updated_at current_sign_in_at last_sign_in_at sign_in_count]
       end

       def self.ransackable_associations(auth_object = nil)
         # No associations should be searchable
         []
       end
     end