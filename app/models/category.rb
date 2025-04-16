# app/models/category.rb
class Category < ApplicationRecord
  has_many :product_categories
  has_many :products, through: :product_categories

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["product_categories", "products"] # Allow these associations to be searchable
  end
end