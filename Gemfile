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
gem 'stripe_event'
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

# CSS & Styling
gem "bootstrap", "~> 5.3"
gem "sassc-rails", "~> 2.1" # Sass compiler for Rails

# Development and Testing
group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false # Security analysis tool
  gem "rubocop-rails-omakase", require: false # Rubocop for Rails
  gem "factory_bot_rails" # For testing (factories)
end

group :development do
  gem "web-console" # Rails console in browser
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby] # Code highlighting for errors
  gem "annotate" # Auto-generate schema comments
  gem "bullet" # N+1 query detection
end

group :test do
  gem "capybara" # Integration testing (browser-based)
  gem "selenium-webdriver" # Webdriver for browser testing
  gem "webdrivers" # Webdriver management
  gem "cypress-rails" # For end-to-end testing (5.5)
  gem 'select2-rails'
end
