class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def self.count_vendors

    Market.all.each do |market|
      market.vendor_count = market.vendors.count
      market.save
    end
  end
end
