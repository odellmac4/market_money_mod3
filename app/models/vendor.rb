class Vendor < ApplicationRecord
  has_many :market_vendors, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :contact_name, presence: true
  validates :contact_phone, presence: true
  # validates :credit_accepted, presence: true
  validate :validate_credit_accepted

  def validate_credit_accepted
    if credit_accepted.nil? || ![true, false].include?(credit_accepted)
      errors.add(:credit_accepted, "must be true or false")
    end
  end
end
