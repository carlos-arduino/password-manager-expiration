class PasswordExpirationJob < ApplicationJob
  queue_as :default
  
  def perform(email_box_id)
    email_box = EmailBox.find(email_box_id)
    email_box.expire_password!
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "EmailBox #{email_box_id} not found: #{e.message}"
  end
end
