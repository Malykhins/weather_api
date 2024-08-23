# Weather_app API
> Ruby 3.2.2
>
> Rails 7.1.3

## Setup
> 1. Install dependencies: `bundle install`
> 2. Create and migrate the database: `rails db:create && rails db:migrate`
> 3. Start the server: `rails s`

Visit [http://localhost:3000/](http://localhost:3000/) to see the app in action.

## API Key for AccuWeather
To run the app, you need an API key from [developer.accuweather.com](https://developer.accuweather.com/).

### Adding the API Key
> 1. Edit credentials: `EDITOR=vi bin/rails credentials:edit`
> 2. Add your API key:

>   development:
>     accuweather:
>       appid: your_accuweather_api_key

### Tests:
> rspec spec
