class Api::V0::MarketsController < ApplicationController
    def index
      binding.pry
        render json: Market.all
    end

    def update
      
    end
end