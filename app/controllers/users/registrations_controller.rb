class Users::RegistrationsController < Devise::RegistrationsController
  # Allow additional parameters during sign-up
  private

  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :address, :phone_number, :province_id)
  end
end
