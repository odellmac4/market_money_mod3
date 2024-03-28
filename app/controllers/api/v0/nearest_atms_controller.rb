class Api::V0::NearestAtmsController < ApplicationController
  def index
    market = params[:market_id]
    @facade = AtmFacade.new(market.lat, market.lon)
  end
end
