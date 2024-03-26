class Api::V0::MarketsController < ApplicationController
    def index
        render json: Market.all
    end
end