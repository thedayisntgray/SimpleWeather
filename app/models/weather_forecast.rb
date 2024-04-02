class WeatherForecast
  include ActiveModel::Model

  attr_accessor :street, :city, :state, :zip
  validates :zip, presence: true
end
