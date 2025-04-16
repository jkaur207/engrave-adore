class Product < ApplicationRecord
  # Associations
  has_and_belongs_to_many :orders, join_table: :orders_products
  has_one_attached :image
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories

  # Validations
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :sale_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Scopes
  scope :on_sale, -> { where.not(sale_price: [nil, 0]) }
  scope :newly_added, -> { where('created_at >= ?', 3.days.ago) }
  scope :recently_updated, -> {
    where('updated_at >= ?', 3.days.ago)
      .where.not(id: Product.where('created_at >= ?', 3.days.ago).select(:id))
  }

  # Instance Methods

  def on_sale?
    sale_price.present? && sale_price < price
  end

  def display_price
    on_sale? ? sale_price : price
  end

  def discontinued?
    discontinued == true
  end

  def active?
    !discontinued?
  end

  # Ransack support
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "price", "sale_price", "updated_at", "discontinued"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["categories", "product_categories", "orders"]
  end
end
