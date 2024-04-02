class WeatherForecast
  include ActiveModel::Model

  attr_accessor :street, :city, :state, :zip
  validates :zip, presence: true

  # This is a naive approach to validating zip codes that doesn't account for all cases.
  validates_format_of :zip,
    with: /\d{5}/, message: "should be in the form 12345"
end
