class OrdersController < ApplicationController
  include TaxHelper
  before_action :authenticate_user!

  def show
    @order = current_user.orders.find(params[:id])
    calculate_order_totals(@order)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Order not found."
  end

  private

  def calculate_order_totals(order)
    @subtotal = order.subtotal || order.order_items.sum { |item| item.price * item.quantity }
    @taxes = {
      gst: order.gst,
      pst: order.pst,
      hst: order.hst,
      qst: order.qst,
      total: order.total
    }
  end
end