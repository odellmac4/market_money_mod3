class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def count_vendors

    Market.all.each do |market|
      market.vendor_count = vendors.count
    end
    binding.pry
  end
end
