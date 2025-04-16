require 'faker'

# Creating an admin user (for development only)
if Rails.env.development?
  AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
    admin.password = 'password'
    admin.password_confirmation = 'password'
  end
  puts "✅ Admin user seeded!"
end

# Creating sample categories
categories = ["Engraved Gifts", "Photo Gifts", "Customized Accessories", "Personalized Jewelry"]
categories.each do |category_name|
  Category.find_or_create_by!(name: category_name)
end
puts "✅ Categories seeded!"

# Sample products with timestamps and random updates
products = [
  { name: "Engraved Wooden Keychain", description: "Custom wooden keychain with personalized engraving.", price: 9.99, category: "Engraved Gifts" },
  { name: "Custom Name Necklace", description: "Beautifully crafted personalized name necklace.", price: 29.99, category: "Personalized Jewelry" },
  { name: "Photo-Printed Coffee Mug", description: "Upload any photo to be printed on a ceramic mug.", price: 14.99, category: "Photo Gifts" },
  { name: "Personalized Leather Wallet", description: "Genuine leather wallet with custom name engraving.", price: 39.99, category: "Customized Accessories" },
  { name: "Engraved Wooden Plaque", description: "Customized wooden plaque with a heartfelt message.", price: 24.99, category: "Engraved Gifts" },
  { name: "Photo Crystal Block", description: "High-quality crystal with a laser-etched photo.", price: 49.99, category: "Photo Gifts" },
  { name: "Custom Charm Bracelet", description: "Personalized charm bracelet with initials or symbols.", price: 34.99, category: "Personalized Jewelry" },
  { name: "Engraved Metal Pen Set", description: "Elegant metal pen set with custom engraving.", price: 19.99, category: "Engraved Gifts" },
  { name: "Custom Embroidered Cap", description: "Stylish cap with personalized embroidery.", price: 17.99, category: "Customized Accessories" },
  { name: "Photo Printed Phone Case", description: "Personalized phone case with a custom photo.", price: 19.99, category: "Photo Gifts" }
]

products.each_with_index do |product, index|
  category = Category.find_by(name: product[:category])
  next unless category

  created_at = Faker::Time.between(from: 20.days.ago, to: 5.days.ago)
  updated_at = [created_at, Faker::Time.between(from: 4.days.ago, to: Time.current)].sample

  product_record = Product.find_or_initialize_by(name: product[:name])
  product_record.assign_attributes(
    description: product[:description],
    price: product[:price],
    created_at: created_at,
    updated_at: updated_at
  )
  product_record.save!

  # Attach category if not already
  product_record.categories << category unless product_record.categories.include?(category)
end

puts "✅ Products seeded!"
