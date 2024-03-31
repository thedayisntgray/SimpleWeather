class WeatherForecastsController < ApplicationController
  def index
  end

  def new
    @weather_forecast = WeatherForecast.new
  end

  def create
    @weather_forecasts = WeatherForecast.new(weather_forecast_params)
    redirect_to @weather_forecasts
  end

  private

  def weather_forecast_params
    params.require(:weather_forecast).permit(:address, :city, :state, :zip)
  end
end
