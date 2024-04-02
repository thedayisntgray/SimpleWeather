class WeatherForecastsController < ApplicationController
  def index
  end

  def new
    @weather_forecast ||= WeatherForecast.new
  end

  def create
    @weather_forecast = WeatherForecast.new(weather_forecast_params)
    if @weather_forecast.invalid? && @weather_forecast.errors.any?
      render :new
    else
      redirect_to @weather_forecast
    end
  end

  private

  def weather_forecast_params
    params.require(:weather_forecast).permit(:street, :city, :state, :zip)
  end
end
