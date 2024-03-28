require "rails_helper"

RSpec.describe "AtmService" do
  it "gets a response", :vcr do
    service = AtmService.new
    lat = 38.9169984
    lon = -77.0320505
    data = service.get_response(lat, lon)
    summary_keys = [:query, :queryType, :queryTime, :numResults, :offset, :totalResults, :fuzzyLevel, :geoBias]

    expect(data).to be_a(Hash)
    expect(data.keys).to eq([:summary, :results])
    expect(data[:summary]).to be_a(Hash)
    expect(data[:summary].keys).to eq(summary_keys)
    expect(data[:results]).to be_an(Array)

    result_keys = [:type, :id, :score, :dist, :info, :poi, :address, :position, :viewport, :entryPoints,]

    data[:results].each do |result|
      expect(result.keys).to eq(result_keys)
      expect(result[:dist]).to be_a(Float)
      expect(result[:poi]).to be_a(Hash)
      expect(result[:poi][:name]).to be_a(String)
      expect(result[:address]).to be_a(Hash)
      expect(result[:address][:freeformAddress]).to be_a(String)
      expect(result[:position]).to be_a(Hash)
      expect(result[:position][:lat]).to be_a(Float)
      expect(result[:position][:lon]).to be_a(Float)
    end
  end
end
