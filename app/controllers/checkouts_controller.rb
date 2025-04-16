class CheckoutsController < ApplicationController
  include TaxHelper
  before_action :ensure_cart_not_empty, only: [:new, :create]
  before_action :authenticate_user!

  def show
    @cart_items = normalize_cart(session[:cart])
    @subtotal = calculate_subtotal(@cart_items)
    @taxes = calculate_taxes(@subtotal, current_user.province)
  end

  def new
    @order = Order.new(
      email: current_user.email,
      province: current_user.province,
      phone_number: current_user.phone_number
    )
    @cart_items = normalize_cart(session[:cart])
  end

  def create
    @order = build_order_with_taxes

    if @order.save
      create_order_items(@order, normalize_cart(session[:cart]))
      session[:cart] = {}
      redirect_to confirmation_checkout_path, notice: "Order placed successfully!"
    else
      @cart_items = normalize_cart(session[:cart])
      flash.now[:alert] = @order.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def confirmation
    @order = current_user.orders.order(created_at: :desc).first

    if @order
      # Set variables needed for the confirmation page
      @subtotal = @order.subtotal || 0
      @pst = @order.pst || 0
      @gst = @order.gst || 0
      @hst = @order.hst || 0
      @qst = @order.qst || 0  # Make sure to include QST if you need it
      @total = @order.total || 0
      # No need to fetch order_items separately as they're accessed via @order.order_items
    else
      redirect_to root_path, alert: "No order found"
    end
  end

  private

  def build_order_with_taxes
    order = current_user.orders.new(order_params)

    # Set order_status as integer (0) for pending
    order.order_status = 0  # or use the enum helper: order.order_status_pending!
    order.payment_status = "paid"

    cart = normalize_cart(session[:cart])
    subtotal = calculate_subtotal(cart)
    taxes = calculate_taxes(subtotal, current_user.province)

    # Add tax_amount to calculation
    total_tax = taxes[:gst] + taxes[:pst] + taxes[:hst] + taxes[:qst]

    order.assign_attributes(
      subtotal: subtotal,
      gst: taxes[:gst],
      pst: taxes[:pst],
      hst: taxes[:hst],
      qst: taxes[:qst],
      total: taxes[:total],
      tax_amount: total_tax  # Set tax_amount correctly
    )
    order
  end

  def ensure_cart_not_empty
    redirect_to(cart_path, alert: "Your cart is empty") if normalize_cart(session[:cart]).blank?
  end

  def order_params
    params.require(:order).permit(
      :name_on_card,
      :phone_number,
      :email,
      :payment_method,
      :billing_address,
      :delivery_address,
      :province
    )
  end

  def calculate_subtotal(cart_items)
    cart_items.sum { |_, d| d[:price].to_f * d[:quantity].to_i }.round(2)
  end

  def create_order_items(order, cart)
    cart.each do |product_id, item_data|
      product = Product.find_by(id: product_id)
      next unless product && item_data[:quantity].to_i.positive?

      order.order_items.create!(
        product: product,
        quantity: item_data[:quantity].to_i,
        price: item_data[:price].to_f
      )
    end
  end
end