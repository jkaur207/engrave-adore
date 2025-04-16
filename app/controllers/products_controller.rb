class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :check_admin, only: [:edit, :update, :destroy]
  before_action :set_product, only: [:show, :edit, :update, :destroy, :remove_image]

  # GET /products
  def index
    # Default products scope
    @products = apply_filters(Product.all).page(params[:page]).per(10)
  end

  # GET /products/search
  def search
    # Start with all products
    @products = Product.all

    # Search by category if the "Search by Category" button was clicked
    if params[:search_by_category]
      if params[:category].present? && params[:category].to_i > 0
        @products = @products.joins(:categories).where("categories.id = ?", params[:category])
      end
    # Search by keyword if the "Search by Keyword" button was clicked
    elsif params[:search_by_keyword]
      if params[:query].present?
        @products = @products.where("name ILIKE ? OR description ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
      end
    end

    # Apply filters and pagination
    @products = apply_filters(@products).page(params[:page]).per(10)

    render :index
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      flash[:notice] = "Product was successfully deleted."
    else
      flash[:alert] = "There was an issue deleting the product."
    end
    redirect_to products_path
  end

  def remove_image
    if @product.image.attached?
      @product.image.purge
      flash[:notice] = "Image was successfully removed."
    else
      flash[:alert] = "No image attached to remove."
    end
    redirect_to edit_product_path(@product)
  end

  private

  def check_admin
    unless current_user&.admin?
      redirect_to products_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def set_product
    @product = Product.find_by(id: params[:id])
    redirect_to products_path, alert: "Product not found" unless @product
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :sale_price, :image, category_ids: [])
  end

  def apply_filters(scope)
    case params[:filter]
    when 'newly_added'
      scope.newly_added
    when 'recently_updated'
      scope.recently_updated
    when 'on_sale'
      scope.on_sale
    else
      scope
    end
  end
end
