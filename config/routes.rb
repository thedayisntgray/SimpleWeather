Rails.application.routes.draw do
  get "/weather_forecasts", to: "weather_forecasts#index"
end
