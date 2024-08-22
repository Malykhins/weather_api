module V1
  class Weather < Grape::API
    prefix 'api'
    version 'v1', using: :path
    format :json

    route :any, '*path' do
      error!("Not Found: Invalid route", 404)
    end

    helpers do
      def handle_errors(message, &block)
        begin
          yield
        rescue StandardError => e
          error!(message + ": #{e.message}", 500)
        end
      end

      def cached_temperatures(current_timestamp)
        cache_key = "temperatures_last_24_hours_#{current_timestamp}"
        Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          Temperature.where(timestamp: (current_timestamp - 24.hours)..current_timestamp).order(timestamp: :asc)
        end
      end

      def fetch_cached_temperatures
        current_timestamp = Time.now.to_i
        cached_temperatures(current_timestamp)
      end

      def fetch_temperature_value(method)
        temperatures = fetch_cached_temperatures
        temperatures.send(method, :value)&.round(1)
      end
    end

    resource :weather do
      desc 'Get current temperature'
      get :current do
        handle_errors("Error fetching current temperature") do
          temperature = Temperature.order(timestamp: :desc).first
          { temperature: temperature&.value }
        end
      end

      desc 'Get historical temperatures'
      get :historical do
        handle_errors("Error fetching historical temperatures") do
          temperatures = fetch_cached_temperatures
          temperatures.map { |t| { timestamp: t.timestamp, value: t.value } }
        end
      end

      desc 'Get maximum temperature in the last 24 hours'
      get 'historical/max' do
        handle_errors("Error fetching maximum temperature") do
          temperature = fetch_temperature_value(:maximum)
          { max_temperature: temperature }
        end
      end

      desc 'Get minimum temperature in the last 24 hours'
      get 'historical/min' do
        handle_errors("Error fetching minimum temperature") do
          temperature = fetch_temperature_value(:minimum)
          { min_temperature: temperature }
        end
      end

      desc 'Get average temperature in the last 24 hours'
      get 'historical/avg' do
        handle_errors("Error fetching average temperature") do
          average = fetch_temperature_value(:average)
          { avg_temperature: average }
        end
      end

      desc 'Get temperature by timestamp'
      params do
        requires :timestamp, type: Integer, desc: 'Timestamp to fetch the temperature for'
      end
      get 'by_time' do
        handle_errors("Error fetching temperature by time") do
          timestamp = params[:timestamp].to_i
          # Границы, в которых находится ближайшая температура к заданной
          lower_bound = timestamp - (1.hour + 10.minutes).to_i
          upper_bound = timestamp + (1.hour + 10.minutes).to_i

          temperature = Temperature.where("timestamp BETWEEN ? AND ?", lower_bound, upper_bound)
                                   .order(Arel.sql("ABS(timestamp - #{timestamp})"))
                                   .first
          if temperature
            { temperature: temperature.value }
          else
            error!('Not Found', 404)
          end
        end
      end

      desc 'Check health status'
      get :health do
        { status: 'OK' }
      end
    end
  end
end
