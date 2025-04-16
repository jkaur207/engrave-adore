# app/models/product_category.rb
class ProductCategory < ApplicationRecord
  belongs_to :product
  belongs_to :category

  def self.ransackable_attributes(auth_object = nil)
    # List all searchable attributes (excluding sensitive ones)
    ["category_id", "created_at", "id", "product_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    # List all searchable associations
    ["category", "product"]
  end
end