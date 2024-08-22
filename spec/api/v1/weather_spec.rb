require 'rails_helper'
require 'vcr'

RSpec.describe 'V1::Weather API', type: :request do
  # before(:all) do
  #   VCR.use_cassette('accuweather_response') do
  #     api_key = Rails.application.credentials.development[:accuweather][:appid2]
  #     location_key = '292195'
  #
  #     response = HTTParty.get(
  #       "http://dataservice.accuweather.com/currentconditions/v1/#{location_key}/historical/24",
  #       query: { apikey: api_key, language: 'en', details: false }
  #     )
  #
  #     puts "Response code: #{response.code}"
  #   end
  # end

  describe 'GET /api/v1/weather/current' do
    it 'returns the current temperature' do
      get '/api/v1/weather/current'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key('temperature')
      expect(JSON.parse(response.body)['temperature']).not_to be_nil
    end
  end

  describe 'GET /api/v1/weather/historical' do
    it 'returns historical temperatures' do
      get '/api/v1/weather/historical'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to be_an(Array)
    end
  end

  describe 'GET /api/v1/weather/historical/max' do
    it 'returns the maximum temperature in the last 24 hours' do
      get '/api/v1/weather/historical/max'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key('max_temperature')
      expect(JSON.parse(response.body)['max_temperature']).not_to be_nil
    end
  end

  describe 'GET /api/v1/weather/historical/min' do
    it 'returns the minimum temperature in the last 24 hours' do
      get '/api/v1/weather/historical/min'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key('min_temperature')
      expect(JSON.parse(response.body)['min_temperature']).not_to be_nil
    end
  end

  describe 'GET /api/v1/weather/historical/avg' do
    it 'returns the average temperature in the last 24 hours' do
      get '/api/v1/weather/historical/avg'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key('avg_temperature')
      expect(JSON.parse(response.body)['avg_temperature']).not_to be_nil
    end
  end

  describe 'GET /api/v1/weather/by_time' do
    let(:timestamp) { Time.now.to_i }

    it 'returns the temperature by timestamp' do
      get "/api/v1/weather/by_time?timestamp=#{timestamp}"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to have_key('temperature')
    end
  end

  describe 'GET /api/v1/weather/health' do
    it 'returns the health status' do
      get '/api/v1/weather/health'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({ 'status' => 'OK' })
    end
  end
end
