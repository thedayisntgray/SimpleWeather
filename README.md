
![Screenshot 2024-04-03 at 6 15 25 PM](https://github.com/thedayisntgray/SimpleWeather/assets/4859128/9ac396a9-ccc0-4e10-8ea4-f127cd9bf4ef)

# Introduction:
SimpleWeather is a Ruby On Rails projects that takes a user address and displays the high and low temperature.

# Requirements
A weather API key from [AccuWeather](https://developer.accuweather.com/). They have a [free tier](https://developer.accuweather.com/packages) that allows you to send 50 requests a day.

# What's included
Standard Rails stuff here.

- Accepts an address as input.
- Retrieves high/low temperatures for given input.
- Caches the forecast details for 30 minutes for all subsequent requests by zip codes.
- Displays an indicator if the result is pulled from the cache.
- Rspec and Capybara for testing
- Error handling

# Lets run it
Sure thing! 

- Sign up for an AccuWeather Account.
- Create a .env file in the project root directory
- Populate that file with the key you recieved from Accuweather and place it in the .env. It should look like so: ACCU_WEATHER_API_KEY=your_api_key_here
- Run ```bundle install```
- Run ```rails s```

Thats it! 👋
