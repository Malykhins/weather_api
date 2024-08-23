require 'rails_helper'

RSpec.describe UpdateWeather, type: :service do
  describe '.call' do
    context 'when the API request is successful' do
      it 'deletes existing temperatures and creates new ones' do
        Temperature.delete_all

        VCR.use_cassette('successful_request') do

          expect { UpdateWeather.call }.to change { Temperature.count }.from(0).to(24)
        end
      end

      it 'logs a success message' do
        VCR.use_cassette('successful_request') do
          expect(Rails.logger).to receive(:info).with(/Weather data loaded successfully/)

          UpdateWeather.call
        end
      end
    end

    context 'when the API request fails' do
      it 'logs an error message' do
        allow(HTTParty).to receive(:get).and_return(double(code: 500, message: 'Internal Server Error'))

        expect(Rails.logger).to receive(:error).with(/Failed to fetch weather data: 500 Internal Server Error/)

        UpdateWeather.call
      end
    end

    context 'when an exception is raised' do
      it 'logs an error message' do
        allow(HTTParty).to receive(:get).and_raise(StandardError.new('Some error'))

        expect(Rails.logger).to receive(:error).with(/Error in UpdateWeather service: Some error/)

        UpdateWeather.call
      end
    end
  end
end
