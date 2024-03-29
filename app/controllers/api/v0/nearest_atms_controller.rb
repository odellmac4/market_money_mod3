class Api::V0::NearestAtmsController < ApplicationController
  def index
    market = Market.find(params[:market_id])
    @atm_facade = AtmFacade.new(market.lat, market.lon)

    render json: AtmSerializer.new(@atm_facade.sorted_atms), status: :ok
  end
end
