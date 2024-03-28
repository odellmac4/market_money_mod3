class Api::V0::NearestAtmsController < ApplicationController
  def index
    market = params[:market_id]
    @facade = AtmFacade.new(market)
  end
end
