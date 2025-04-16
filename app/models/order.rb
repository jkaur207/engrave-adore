class Order < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :price_snapshots, through: :order_items
  accepts_nested_attributes_for :order_items, allow_destroy: true

  # Tax Rates by Province (defined early to avoid uninitialized constant error)
  PROVINCIAL_TAX_RATES = {
    'AB' => { gst: 0.05 },
    'BC' => { gst: 0.05, pst: 0.07 },
    'MB' => { gst: 0.05, pst: 0.07 },
    'NB' => { hst: 0.15 },
    'NL' => { hst: 0.15 },
    'NT' => { gst: 0.05 },
    'NS' => { hst: 0.15 },
    'NU' => { gst: 0.05 },
    'ON' => { hst: 0.13 },
    'PE' => { hst: 0.15 },
    'QC' => { gst: 0.05, qst: 0.09975 },
    'SK' => { gst: 0.05, pst: 0.06 },
    'YT' => { gst: 0.05 }
  }.freeze

  # Enums with prefixes to avoid conflicts - UPDATED to use integers
  enum order_status: {
    pending: 0,
    completed: 1,
    cancelled: 2
  }, _prefix: :order_status

  enum payment_status: {
    unpaid: "unpaid",
    processing: "processing",
    paid: "paid",
    failed: "failed",
    refunded: "refunded"
  }, _prefix: :payment_status

  # Validations
  validates :order_status, :payment_status, :user_id, :province, presence: true
  validates :order_number, uniqueness: true
  validates :province, inclusion: { in: PROVINCIAL_TAX_RATES.keys }
  validates :subtotal, :total, :tax_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Callbacks
  before_validation :generate_order_number, on: :create
  before_save :calculate_financials, if: :should_recalculate_financials?
  after_commit :update_order_totals, on: [:create, :update]

  # Instance Methods

  def calculate_subtotal
    order_items.sum(&:total_price).round(2)
  end

  def calculate_taxes
    rates = PROVINCIAL_TAX_RATES[province] || PROVINCIAL_TAX_RATES['ON']
    current_subtotal = calculate_subtotal

    self.gst = (current_subtotal * (rates[:gst] || 0)).round(2)
    self.pst = (current_subtotal * (rates[:pst] || 0)).round(2)
    self.hst = (current_subtotal * (rates[:hst] || 0)).round(2)
    self.qst = (current_subtotal * (rates[:qst] || 0)).round(2)
    self.tax_amount = (gst + pst + hst + qst).round(2)
  end

  def calculate_total
    (calculate_subtotal + tax_amount).round(2)
  end

  def calculate_financials
    self.subtotal = calculate_subtotal
    calculate_taxes
    self.total = calculate_total
  end

  def update_order_totals
    calculate_financials
    save! if changed?
  end

  def generate_invoice
    {
      order_number: order_number,
      date: created_at.strftime('%Y-%m-%d'),
      customer_info: {
        name: user.username,
        email: user.email,
        province: province
      },
      items: order_items.includes(:product, :price_snapshot).map do |item|
        {
          product: item.product.name,
          quantity: item.quantity,
          unit_price: item.unit_price,
          total_price: item.total_price
        }
      end,
      subtotal: subtotal,
      taxes: {
        gst: gst,
        pst: pst,
        hst: hst,
        qst: qst
      },
      total: total,
      payment_status: payment_status,
      payment_method: payment_method,
      payment_id: payment_id,
      paid_at: paid_at
    }
  end

  private

  def generate_order_number
    return if order_number.present?

    date_part = Time.current.strftime('%Y%m%d')
    random_part = SecureRandom.alphanumeric(6).upcase
    self.order_number = "ORD-#{date_part}-#{random_part}"
  end

  def should_recalculate_financials?
    order_items.loaded? && (
      order_items.any? { |item| item.new_record? || item.quantity_changed? } ||
      order_items.any?(&:marked_for_destruction?) ||
      province_changed?
    )
  end
end