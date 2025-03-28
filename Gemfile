source "https://rubygems.org"

# Core Rails
gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "bootsnap", require: false

# Frontend
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "sprockets-rails"
gem "jbuilder"

# Authentication & Authorization
gem "devise"
gem "pundit"

# Admin Dashboard
gem "activeadmin"
gem "arctic_admin" # Optional for better ActiveAdmin UI

# Payments
gem "stripe"
gem "money-rails"

# Product Management
gem "faker", "~> 3.2" # For seeding data (specified once here)
gem "kaminari" # Pagination (required for 2.5)
gem "ransack" # For search functionality (2.6)

# Shopping Cart
gem "acts_as_shopping_cart" # Optional alternative to custom cart

# Images & File Uploads
gem "image_processing", "~> 1.2"
gem "aws-sdk-s3" # For ActiveStorage if using AWS

# Canadian Taxes (Alternative to 'provinces' gem)
gem "canada_post" # For Canadian postal codes and provinces
# OR manually create provinces table (see note below)

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "factory_bot_rails" # For testing
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
  gem "annotate" # Auto-generate schema comments
  gem "bullet" # N+1 query detection
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "cypress-rails" # For end-to-end testing (5.5)
end