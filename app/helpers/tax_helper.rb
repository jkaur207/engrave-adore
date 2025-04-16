module TaxHelper
  PROVINCE_TAX_RATES = {
    "ON" => { gst: 0.0,  pst: 0.0,     hst: 0.13 },
    "QC" => { gst: 0.05, qst: 0.09975, hst: 0.0 },
    "BC" => { gst: 0.05, pst: 0.07,    hst: 0.0 },
    "AB" => { gst: 0.05, pst: 0.0,     hst: 0.0 },
    "MB" => { gst: 0.05, pst: 0.07,    hst: 0.0 },
    "SK" => { gst: 0.05, pst: 0.06,    hst: 0.0 },
    "NS" => { gst: 0.0,  pst: 0.0,     hst: 0.15 },
    "NB" => { gst: 0.0,  pst: 0.0,     hst: 0.15 },
    "NL" => { gst: 0.0,  pst: 0.0,     hst: 0.15 },
    "PE" => { gst: 0.0,  pst: 0.0,     hst: 0.15 },
    "NT" => { gst: 0.05, pst: 0.0,     hst: 0.0 },
    "NU" => { gst: 0.05, pst: 0.0,     hst: 0.0 },
    "YT" => { gst: 0.05, pst: 0.0,     hst: 0.0 }
  }.freeze

  def calculate_taxes(subtotal, province)
    province = province.to_s.upcase
    rates = PROVINCE_TAX_RATES.fetch(province, PROVINCE_TAX_RATES["MB"])
    subtotal = subtotal.to_f.clamp(0.0, Float::INFINITY)

    tax_keys = %i[gst pst hst qst]
    taxes = tax_keys.index_with do |key|
      (subtotal * (rates[key] || 0)).round(2)
    end

    taxes[:total] = (subtotal + taxes.values.sum).round(2)
    taxes
  end

  def normalize_cart(cart_data)
    return {} unless cart_data.is_a?(Hash)

    cart_data.each_with_object({}) do |(product_id, item_data), hash|
      next unless product_id.present? && item_data.is_a?(Hash)

      quantity = item_data["quantity"] || item_data[:quantity]
      price    = item_data["price"]    || item_data[:price]
      name     = item_data["name"]     || item_data[:name]

      next unless quantity.to_i > 0

      hash[product_id.to_s] = {
        quantity: quantity.to_i,
        price: price.to_f,
        name: name
      }
    end
  end
end
