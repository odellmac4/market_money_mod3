require 'rails_helper'

describe "Markets Api" do
    it 'send a list of markets' do
      create_list(:market, 4)

      get '/api/v0/markets'

      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)

      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market).to have_key(:name)
        expect(market).to have_key(:street)
        expect(market).to have_key(:city)
        expect(market).to have_key(:county)
        expect(market).to have_key(:state)
        expect(market).to have_key(:zip)
        expect(market).to have_key(:lat)
        expect(market).to have_key(:lon)
        
        expect(market[:name]).to be_an(String)
        expect(market[:street]).to be_an(String)
        expect(market[:city]).to be_an(String)
        expect(market[:county]).to be_an(String)
        expect(market[:state]).to be_an(String)
        expect(market[:zip]).to be_an(String)
        expect(market[:lat]).to be_an(String)
        expect(market[:lon]).to be_an(String)


      end
    end
end