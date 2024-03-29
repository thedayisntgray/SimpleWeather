Rails.application.routes.draw do
  root "weather_forecasts#new"
  get "/weather_forecasts", to: "weather_forecasts#index"
end
