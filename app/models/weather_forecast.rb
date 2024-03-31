class WeatherForecast
  include ActiveModel::Model

  attr_accessor :address, :city, :state, :zip
end
