class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor
  validates :vendor_id, presence: true
  validates :market_id, presence: true
  validate :valid_market_vendor

  def valid_market_vendor
    if MarketVendor.find_by(market_id: market_id, vendor_id: vendor_id)
      errors.add(:market_vendor, "association between market with market_id=#{market_id} and vendor_id=#{vendor_id} already exists")
    end
  end
end
