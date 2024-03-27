require 'rails_helper'

describe "Markets Api" do
  it 'send a list of markets' do
    create_list(:market, 4)

    get '/api/v0/markets'

    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)
    markets[:data].each do |market|
      expect(market).to have_key(:id)
      expect(market).to have_key(:type)
      expect(market).to have_key(:attributes)
      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes]).to have_key(:vendor_count)

      expect(market[:id]).to be_a(String)
      expect(market[:type]).to be_a(String)
      expect(market[:attributes]).to be_a(Hash)
      expect(market[:attributes][:name]).to be_a(String)
      expect(market[:attributes][:street]).to be_a(String)
      expect(market[:attributes][:city]).to be_a(String)
      expect(market[:attributes][:county]).to be_a(String)
      expect(market[:attributes][:state]).to be_a(String)
      expect(market[:attributes][:zip]).to be_a(String)
      expect(market[:attributes][:lat]).to be_a(String)
      expect(market[:attributes][:lon]).to be_a(String)
      expect(market[:attributes][:vendor_count]).to be_an(Integer)
    end
  end

  it "can get one market by its id" do
    id = create(:market).id
  
    get "/api/v0/markets/#{id}"
  
    market = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    
    market_info = market[:data]
    expect(market_info).to be_a(Hash)

    expect(market_info).to have_key(:id)
    expect(market_info[:id]).to eq("#{id}")
  
    expect(market_info).to have_key(:type)
    expect(market_info[:type]).to eq("market")
  
    expect(market_info).to have_key(:attributes)
    expect(market_info[:attributes]).to be_a(Hash)

  end
end
