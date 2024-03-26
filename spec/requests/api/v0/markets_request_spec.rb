require 'rails_helper'

describe "Markets Api" do
  it 'send a list of markets' do
    create_list(:market, 4)

    get '/api/v0/markets'

    expect(response).to be_successful

    markets_parsed_response = JSON.parse(response.body, symbolize_names: true)

    markets = markets_parsed_response[:data]
   
    markets.each do |market|
      market_info = market[:attributes]

      expect(market).to have_key(:id)
      expect(market_info).to have_key(:name)
      expect(market_info).to have_key(:street)
      expect(market_info).to have_key(:city)
      expect(market_info).to have_key(:county)
      expect(market_info).to have_key(:state)
      expect(market_info).to have_key(:zip)
      expect(market_info).to have_key(:lat)
      expect(market_info).to have_key(:lon)
      expect(market_info).to have_key(:vendor_count)
      
      expect(market_info[:name]).to be_an(String)
      expect(market_info[:street]).to be_an(String)
      expect(market_info[:city]).to be_an(String)
      expect(market_info[:county]).to be_an(String)
      expect(market_info[:state]).to be_an(String)
      expect(market_info[:zip]).to be_an(String)
      expect(market_info[:lat]).to be_an(String)
      expect(market_info[:lon]).to be_an(String)
      expect(market_info[:vendor_count]).to be_an(Integer)


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