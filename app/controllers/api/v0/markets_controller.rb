class Api::V0::MarketsController < ApplicationController
    def index
        render json: MarketSerializer.new(Market.all)
    end
<<<<<<< HEAD

    def show
        market = Market.find(params[:id])
        render json: MarketSerializer.new(market)
    end
end
=======
end
>>>>>>> 479a06f35983ce37b4b96b659e78bf0af7367b5a
