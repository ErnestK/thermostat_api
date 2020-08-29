# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ValidateReadingService, '#call' do
  include Dry::Monads[:result]

  let(:subject) { described_class }

  let(:valid_reading_value) do
    ReadingValue.new(
      id: 1,
      number: 1,
      household_token: '1',
      temperature: 1,
      humidity: 1,
      battery_charge: 1
    )
  end

  context 'when reading_value is valid' do
    it 'returns true in Success' do
      create(:thermostat)

      result = subject.new(valid_reading_value).call

      expect(result).to eq Success(true)
    end
  end

  context 'when thermostat does not exists' do
    it 'returns failure with message' do
      result = subject.new(valid_reading_value).call

      expect(result).to eq Failure('Thermostat with that token no found, missing household_token: 1')
    end
  end

  context 'when temperature is invalid' do
    it 'returns failure with message' do
      create(:thermostat)
      valid_reading_value.temperature = 29_299

      result = subject.new(valid_reading_value).call

      expect(result).to eq Failure('Temperature must be between -200 and 200, corrupt temperature: 29299')
    end
  end

  context 'when humudity is invalid' do
    it 'returns failure with message' do
      create(:thermostat)
      valid_reading_value.humidity = 991

      result = subject.new(valid_reading_value).call

      expect(result).to eq Failure('Humidity charge must be between -100 and 100, corrupt humidity: 991')
    end
  end

  context 'when battery_charge is invalid' do
    it 'returns failure with message' do
      create(:thermostat)
      valid_reading_value.battery_charge = -29_299

      result = subject.new(valid_reading_value).call

      expect(result).to eq Failure('Battery charge must be between 0 and 100, corrupt battery charge: -29299')
    end
  end
end
