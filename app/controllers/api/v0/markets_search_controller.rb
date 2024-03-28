class Api::V0::MarketsSearchController < ApplicationController
  def index
    markets = Market.all

    if markets_search_params.present?
      markets = markets.where("name LIKE ? AND state LIKE ? AND city LIKE ?", "%#{market_name}%", "%#{state}%", "%#{city}%")

    elsif (state.present? || market_name.present?) || (state.present? && market_name.present?)
      markets = markets.where("name LIKE ? AND state LIKE ?", "%#{market_name}%", "%#{state}%")
  
    elsif state.present? && city.present?
      markets = markets.where("state LIKE ? AND city LIKE ?", "%#{state}%", "%#{city}%")

    end
    markets
    render json: MarketSerializer.new(markets)
  end

  private

  def markets_search_params
    params.permit(
      :name,
      :city,
      :state
      )
  end

  def state
    markets_search_params[:state]
  end

  def city
    markets_search_params[:city]
  end

  def market_name
    markets_search_params[:name]
  end
end