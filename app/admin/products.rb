# app/admin/products.rb
ActiveAdmin.register Product do
  # Fix the filter
  filter :categories_id_in,
         as: :select,
         collection: -> { Category.pluck(:name, :id) },
         label: "Category"

  # Remove duplicate image column from form
  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :price
      f.input :categories,
              as: :select,
              multiple: true,
              collection: Category.all,
              input_html: { class: 'select2' }
      f.input :image, as: :file
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :name
    column "Categories" do |product|
      product.categories.map(&:name).join(', ')
    end
    column :price
    column "Image" do |product|
      if product.image.attached?
        image_tag url_for(product.image), width: 50, height: 50
      else
        "No Image"
      end
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :price
      row "Categories" do |product|
        product.categories.map(&:name).join(', ')
      end
      row "Image" do |product|
        if product.image.attached?
          image_tag url_for(product.image), width: 100
        else
          "No Image"
        end
      end
    end
    active_admin_comments
  end

  permit_params :name, :description, :price, :image, category_ids: []
end