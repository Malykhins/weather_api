require 'rails_helper'

RSpec.describe UpdateWeatherJob, type: :job do
  include ActiveJob::TestHelper

  it 'queues the job' do
    expect { described_class.perform_later }.to have_enqueued_job(described_class)
  end


  it 'perform job' do
    Temperature.delete_all

    VCR.use_cassette('successful_request') do
      perform_enqueued_jobs do
        described_class.perform_later
      end

      expect(Temperature.count).to be > 0
    end
  end
end
