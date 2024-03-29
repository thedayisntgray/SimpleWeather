class WeatherForecastsController < ApplicationController
  def index
  end

  def new
    @weather_forecast = WeatherForecast.new
  end
end
