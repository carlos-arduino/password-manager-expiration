class Domain < ApplicationRecord
  has_many :email_boxes, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :password_expiration_frequency, presence: true,
            inclusion: { in: [30, 60, 90, 180] }
end
