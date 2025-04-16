# app/models/price_snapshot.rb
class PriceSnapshot < ApplicationRecord
  belongs_to :product
  belongs_to :order, optional: true
  belongs_to :order_item, optional: true

  validates :price, presence: true,
                   numericality: {
                     greater_than_or_equal_to: 0,
                     message: "must be zero or positive"
                   }
  validates :effective_date, presence: true

  # For ActiveAdmin search functionality
  def self.ransackable_attributes(auth_object = nil)
    %w[id price effective_date created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[product order order_item]
  end
end