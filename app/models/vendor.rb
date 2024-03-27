class Vendor < ApplicationRecord
has_many :market_vendors, dependent: :destroy
end
