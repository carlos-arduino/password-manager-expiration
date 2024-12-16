class CheckExpiredPasswordsJob < ApplicationJob
  queue_as :default
  
  def perform
    EmailBox.where('password_expiration_date <= ?', Time.current).find_each do |email_box|
      PasswordExpirationJob.perform_later(email_box.id)
    end
  end
end
