Rails.application.routes.draw do
  root "weather_forecasts#index"
  get "/weather_forecasts", to: "weather_forecasts#index"
end
