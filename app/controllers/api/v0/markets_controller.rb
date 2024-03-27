class Api::V0::MarketsController < ApplicationController
    def index
        render json: MarketSerializer.new(Market.all)
    end

    def show
        market = Market.find(params[:id])
        render json: MarketSerializer.new(market)
    end
end
