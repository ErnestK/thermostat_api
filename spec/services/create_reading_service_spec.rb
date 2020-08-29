# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateReadingService, '#call' do
  include Dry::Monads[:result]

  let(:subject) { described_class }
  let(:reading_id) { 1 }
  let(:valid_reading_value) do
    ReadingValue.new(
      id: reading_id,
      number: 1,
      household_token: '1',
      temperature: 1,
      humidity: 1,
      battery_charge: 1
    )
  end

  before(:each) do
    Redis.current.flushall
  end

  context 'when reading is valid' do
    it 'creates new reading' do
      create(:thermostat)
      CacheReadings::PushService.new(valid_reading_value).call

      result = subject.new(reading_id).call

      expect(result).to eq Success(true)
      expect(Reading.count).to eq 1
    end
  end
end
