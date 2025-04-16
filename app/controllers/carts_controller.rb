class CartsController < ApplicationController
  before_action :initialize_cart

  # Show the contents of the cart
  def show
    @total_price = @cart_items.sum do |_, details|
      details["price"].to_f * details["quantity"].to_i
    end
  end

  # Add a product to the cart
  def add_to_cart
    product = Product.find(params[:product_id])

    session[:cart] ||= {}

    session[:cart][product.id.to_s] ||= {
      "quantity" => 0,
      "name" => product.name,
      "price" => product.price
    }

    session[:cart][product.id.to_s]["quantity"] += 1

    flash[:notice] = "#{product.name} added to cart!"
    redirect_to cart_path
  end

  # Remove a product from the cart
  def remove_from_cart
    product_id = params[:product_id].to_s
    product_name = session[:cart][product_id]["name"] rescue "Item"

    if session[:cart][product_id]
      session[:cart].delete(product_id)
      flash[:notice] = "#{product_name} was removed from your cart."
    else
      flash[:alert] = "Item not found in cart."
    end

    redirect_to cart_path
  end

  # Update quantity of a product in the cart
  def update_quantity
    product_id = params[:product_id].to_s
    new_quantity = params[:quantity].to_i

    if session[:cart][product_id]
      if new_quantity > 0
        session[:cart][product_id]["quantity"] = new_quantity
        flash[:notice] = "Quantity updated!"
      else
        session[:cart].delete(product_id)
        flash[:notice] = "Item removed from cart (quantity set to zero)."
      end
    else
      flash[:alert] = "Item not found in cart."
    end

    redirect_to cart_path
  end

  # Clear the entire cart
  def clear_cart
    session[:cart] = {}
    flash[:notice] = "Your cart has been cleared."
    redirect_to cart_path
  end

  private

  def initialize_cart
    session[:cart] ||= {}
    @cart_items = session[:cart]
  end
end
