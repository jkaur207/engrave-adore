require 'faker'

# ✅ Seed provinces (No products or categories to seed)
PROVINCE_TAX_RATES = {
  "ON" => { name: "Ontario", gst: 0.0, pst: 0.0, hst: 0.13 },
  "QC" => { name: "Quebec", gst: 0.05, pst: 0.09975, hst: 0.0 },
  "BC" => { name: "British Columbia", gst: 0.05, pst: 0.07, hst: 0.0 },
  "AB" => { name: "Alberta", gst: 0.05, pst: 0.0, hst: 0.0 },
  "MB" => { name: "Manitoba", gst: 0.05, pst: 0.07, hst: 0.0 },
  "SK" => { name: "Saskatchewan", gst: 0.05, pst: 0.06, hst: 0.0 },
  "NS" => { name: "Nova Scotia", gst: 0.0, pst: 0.0, hst: 0.15 },
  "NB" => { name: "New Brunswick", gst: 0.0, pst: 0.0, hst: 0.15 },
  "NL" => { name: "Newfoundland and Labrador", gst: 0.0, pst: 0.0, hst: 0.15 },
  "PE" => { name: "Prince Edward Island", gst: 0.0, pst: 0.0, hst: 0.15 },
  "NT" => { name: "Northwest Territories", gst: 0.05, pst: 0.0, hst: 0.0 },
  "NU" => { name: "Nunavut", gst: 0.05, pst: 0.0, hst: 0.0 },
  "YT" => { name: "Yukon", gst: 0.05, pst: 0.0, hst: 0.0 }
}

puts "Seeding provinces..."
PROVINCE_TAX_RATES.each do |code, data|
  Province.find_or_create_by!(code: code) do |province|
    province.name = data[:name]
    province.gst = data[:gst]
    province.pst = data[:pst]
    province.hst = data[:hst]
  end
end
puts "Provinces seeded!"
