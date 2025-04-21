class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Permit custom fields for sign_up and account_update actions
  def configure_permitted_parameters
    # For sign_up action (new user registration)
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :terms_and_conditions, :address, :phone_number])

    # For account_update action (updating user profile)
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :address, :phone_number])
  end

  # Redirect after login for different user types
  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      admin_root_path  # Redirect to ActiveAdmin dashboard
    else
      root_path  # Redirect regular users to homepage
    end
  end
end
