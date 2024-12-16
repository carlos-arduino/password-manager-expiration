class EmailBox < ApplicationRecord
  belongs_to :domain
 
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, presence: true
  validates :password_expiration_date, presence: true
  
  before_validation :set_password_expiration_date, on: :create
  after_create :schedule_password_expiration
  
  # Adds password virtual attributes and encryption
  has_secure_password
  
  # Updates password and resets expiration date
  def expire_password!
    new_password = SecureRandom.hex(12)
    update!(
      password: new_password,
      password_expiration_date: calculate_next_expiration_date
    )
    # Here you might want to send the new password via email or another secure channel
    new_password
  end
  
  private
  
  def set_password_expiration_date
    self.password_expiration_date = calculate_next_expiration_date
  end
  
  def calculate_next_expiration_date
    Time.current + domain.password_expiration_frequency.days
  end
  
  def schedule_password_expiration
    PasswordExpirationJob.set(wait_until: password_expiration_date)
                        .perform_later(id)
  end
end
