class UpdateWeatherJob < ApplicationJob
  queue_as :default

  def perform
    UpdateWeather.call
  end
end
