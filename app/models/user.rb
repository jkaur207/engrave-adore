class User < ApplicationRecord
  has_many :orders

  # Devise authentication modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enum for roles (string type)
  enum role: { customer: 'customer', admin: 'admin' }

  # Set default role to 'customer' if not specified
  after_initialize :set_default_role, if: :new_record?

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :phone_number, presence: true, uniqueness: true, format: { with: /\A[+]?[0-9]{10,15}\z/, message: "must be a valid phone number" }
  validates :address, presence: true  # Make sure address is required
  validates :terms_and_conditions, acceptance: { accept: true }, on: :create, if: :new_record?

  # Ransack searchability
  def self.ransackable_attributes(auth_object = nil)
    [
      "address", "confirmation_sent_at", "phone_number", "confirmation_token", "confirmed_at",
      "created_at", "current_sign_in_at", "current_sign_in_ip", "email",
      "failed_attempts", "id", "last_sign_in_at", "last_sign_in_ip", "locked_at",
      "remember_created_at", "reset_password_sent_at", "reset_password_token", "role",
      "sign_in_count", "terms_and_conditions", "unconfirmed_email", "unlock_token",
      "updated_at", "username"
    ]
  end

  # Specify the associations that should be searchable
  def self.ransackable_associations(auth_object = nil)
    ["orders"]
  end

  private

  def set_default_role
    self.role ||= :customer
  end
end
