require "rails_helper"

RSpec.describe "AtmService" do
  it "gets a connection" do
    service = AtmService.new

    lat = 38.9169984
    lon = -77.0320505

    response = service.get_response(lat, lon)
    require 'pry'; binding.pry

    expect(response).to be_successful
  end
end
