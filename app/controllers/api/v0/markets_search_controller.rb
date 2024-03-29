class Api::V0::MarketsSearchController < ApplicationController

  def index
    if state_or_name_present? && !city_and_name_without_state?
      markets_search_requirements
    else
      invalid_params_response
    end
  end

  private

  def state_or_name_present?
    (state.present? || market_name.present?)
  end

  def city_and_name_without_state?
    city.present? && market_name.present? && !state.present?
  end

  def markets_search_requirements
    markets = Market.all

    if state_and_market_present?
      markets = markets.match_state_name(market_name, state)
    elsif state_and_city_present?
      markets = markets.match_state_city(state, city)
    elsif only_state_present?
      markets = markets.match_state(state)
    else
      markets = markets.match_name_city_state(market_name, city, state)
    end
    render json: MarketSerializer.new(markets), status: :ok
  end

  def state
    params[:state]
  end

  def market_name
    params[:name]
  end

  def city
    params[:city]
  end

  def only_state_present?
    state.present? && !market_name.present? && !city.present?
  end

  def state_and_market_present?
    state.present? && market_name.present?
  end

  def state_and_city_present?
    state.present? && city.present?
  end

  def invalid_params_response
      render json: ErrorSerializer.new(ErrorMessage.new("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.", 422))
      .serializer_validation, status: :unprocessable_entity
  end
end
