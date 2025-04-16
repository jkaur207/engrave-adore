class OrderItem < ApplicationRecord
  # Associations
  belongs_to :order, touch: true
  belongs_to :product
  belongs_to :price_snapshot, optional: true

  # Validations
  validates :quantity, presence: true,
                       numericality: {
                         greater_than: 0,
                         only_integer: true,
                         message: "must be a positive whole number"
                       }
  validates :price, presence: true,
                    numericality: { greater_than: 0 }
  validates :price_snapshot, presence: true, unless: :new_record?
  validate :product_available_for_purchase, on: :create

  # Callbacks
  before_validation :capture_price_snapshot, on: :create
  before_save :set_price_from_snapshot
  after_commit :update_order_subtotal, on: [:create, :update, :destroy]

  # Price calculations
  def unit_price
    price || price_snapshot&.price || product&.price || 0
  end

  def total_price
    (unit_price * quantity).round(2)
  end

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[id quantity price created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[order product price_snapshot]
  end

  private

  def capture_price_snapshot
    return if price_snapshot.present? || product.nil?

    self.price_snapshot = PriceSnapshot.create(
      product: product,
      price: product.price,
      effective_date: Time.current,
      order: order
    )
    self.price = price_snapshot.price
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, "Failed to capture price snapshot: #{e.message}")
  end

  def set_price_from_snapshot
    self.price = price_snapshot.price if price_snapshot && price.nil?
  end

  # 🔁 Only update subtotal, not taxes
  def update_order_subtotal
    order.reload
    order.calculate_subtotal
    order.save
  end

  def product_available_for_purchase
    return if product.nil?

    if product.discontinued?
      errors.add(:product, "cannot be added to order as it has been discontinued")
    elsif !product.active?
      errors.add(:product, "is currently not available for purchase")
    elsif product.price.blank? || product.price <= 0
      errors.add(:product, "has an invalid price and cannot be ordered")
    end
  end
end
