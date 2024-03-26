class Api::V0::MarketsController < ApplicationController
    def index
        render json: Market.count_vendors
    end

    def update

    end
end