class UpdateWeatherJob < ApplicationJob
  queue_as :default

  def perform
    response = HTTParty.get(
      "http://dataservice.accuweather.com/currentconditions/v1/#{location_key}/historical/24",
      query: { apikey: api_key, language: 'en', details: false }
    )

    if response.code == 200
      Temperature.delete_all

      response.parsed_response.each do |data|
        Temperature.create(timestamp: data['EpochTime'], value: data['Temperature']['Metric']['Value'])
      end

      Rails.logger.info "Weather data loaded successfully at #{Time.now}"
    else
      Rails.logger.error "Failed to fetch weather data: #{response.code} #{response.message}"
    end
  rescue StandardError => e
    Rails.logger.error "Error in UpdateWeatherJob: #{e.message}"
  end

private

  def api_key
    Rails.application.credentials.development[:accuweather][:appid2]
  end

  # Соответствует г.Белгород
  def location_key
    '292195'
  end
end
