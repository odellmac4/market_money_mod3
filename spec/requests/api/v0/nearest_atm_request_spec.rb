require "rails_helper"

describe "nearest atm request" do
  it "can find the nearest atms to a Market", :vcr do
    market = Market.create!(
      name: "Store",
      street: "3902 Central Avenue",
      city: "Maricopa",
      state: "Arizona",
      zip: "95626",
      lat: "24.23423",
      lon: "-83.343",
      vendor_count: 0
    )

    get "/api/v0/markets/#{market.id}/nearest_atms"

    expect(response).to be_successful
    expect(response.status).to eq(200)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to be_a(Hash)
    expect(data[:data]).to be_an(Array)

    data[:data].each do |atm|
      expect(atm.keys).to eq([:id, :type, :attributes])
      expect(atm[:id]).to eq(nil)
      expect(atm[:type]).to eq("atm")
      expect(atm[:attributes]).to be_a(Hash)
      expect(atm[:attributes].keys).to eq([:name, :address, :lat, :lon, :distance])
      expect(atm[:attributes][:name]).to be_a(String)
      expect(atm[:attributes][:address]).to be_a(String)
      expect(atm[:attributes][:lat]).to be_a(Float)
      expect(atm[:attributes][:lon]).to be_a(Float)
      expect(atm[:attributes][:distance]).to be_a(Float)
    end
  end
end
