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
    @order.order_status = 0  # pending
    @order.payment_status = "unpaid"

    if @order.save
      create_order_items(@order, normalize_cart(session[:cart]))

      # Store order ID for payment confirmation later
      session[:pending_order_id] = @order.id

      if params[:order][:payment_method] == "credit_card"
        redirect_to create_checkout_session_path  # go to Stripe
      else
        # PayPal or bank transfer
        session[:cart] = {}
        @order.update(payment_status: "paid")
        redirect_to confirmation_checkout_path, notice: "Order placed successfully!"
      end
    else
      @cart_items = normalize_cart(session[:cart])
      flash.now[:alert] = @order.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def create_checkout_session
    order = Order.find(session[:pending_order_id])

    line_items = order.order_items.map do |item|
      {
        price_data: {
          currency: 'cad',
          product_data: {
            name: item.product.name
          },
          unit_amount: (item.price * 100).to_i
        },
        quantity: item.quantity
      }
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: line_items,
      mode: 'payment',
      success_url: "#{root_url}checkout/confirmation?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: "#{root_url}cart"
    )

    redirect_to session.url, allow_other_host: true
  end

  def confirmation
    @order = current_user.orders.order(created_at: :desc).first

    if @order && @order.payment_status != "paid"
      @order.update(payment_status: "paid")
      session[:cart] = {}
    end

    if @order
      @subtotal = @order.subtotal || 0
      @pst = @order.pst || 0
      @gst = @order.gst || 0
      @hst = @order.hst || 0
      @qst = @order.qst || 0
      @total = @order.total || 0
    else
      redirect_to root_path, alert: "No order found"
    end
  end

  private

  def build_order_with_taxes
    order = current_user.orders.new(order_params)
    cart = normalize_cart(session[:cart])
    subtotal = calculate_subtotal(cart)
    taxes = calculate_taxes(subtotal, current_user.province)

    total_tax = taxes[:gst] + taxes[:pst] + taxes[:hst] + taxes[:qst]

    order.assign_attributes(
      subtotal: subtotal,
      gst: taxes[:gst],
      pst: taxes[:pst],
      hst: taxes[:hst],
      qst: taxes[:qst],
      total: taxes[:total],
      tax_amount: total_tax
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
