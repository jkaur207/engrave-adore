class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :terms_and_conditions])
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
