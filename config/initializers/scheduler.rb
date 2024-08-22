require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

Rails.logger.info "Scheduler started at #{Time.now}"

scheduler.at Time.now do
  Rails.logger.info "First scheduler is running at #{Time.now}"
  UpdateWeatherJob.perform_later
end

scheduler.interval '1h' do
  Rails.logger.info "Interval scheduler is running at #{Time.now}"
  UpdateWeatherJob.perform_later
end
