class Api::V0::NearestAtmsController < ApplicationController
  def index
    market = Market.find(params[:market_id])
    @atm_facade = AtmFacade.new(market.lat, market.lon)

    render json: AtmSerializer.new(@facade.sorted_atms).serialize_data, status: :ok
  end
end