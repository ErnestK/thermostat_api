# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddReadingService, '#call' do
  include Dry::Monads[:result]

  let(:valid_hash_params) do
    {
      id: 1,
      number: 1,
      household_token: '1',
      temperature: 1,
      humidity: 1,
      battery_charge: 1,
    }
  end

  context 'when all data is correct' do
    it 'Add new data in table' do
      create(:thermostat)

      result = AddReadingService.new(valid_hash_params).call

      expect(result).to eq Success(true)
      expect(Reading.count).to eq 1
    end
  end

  context 'when thermostat with id not exist' do
    it 'Return failure with message' do
      result = AddReadingService.new(valid_hash_params).call

      expect(result).to eq Failure("Thermostat with that token no found, missing household_token: 1")
    end
  end

  context 'when temperature invalid' do
    it 'return failure with message' do
      create(:thermostat)
      result = AddReadingService.new(valid_hash_params.merge(temperature: 29_299)).call

      expect(result).to eq Failure("Temperature must be between -200 and 200, corrupt temperature: 29299")
    end
  end

  context 'when humidity invalid' do
    it 'return failure with message' do
      create(:thermostat)
      result = AddReadingService.new(valid_hash_params.merge(humidity: 991)).call

      expect(result).to eq Failure("Humidity charge must be between -100 and 100, corrupt humidity: 991")
    end
  end

  context 'when battery_charge invalid' do
    it 'return failure with message' do
      create(:thermostat)
      result = AddReadingService.new(valid_hash_params.merge(battery_charge: -29_299)).call

      expect(result).to eq Failure("Battery charge must be between 0 and 100, corrupt battery charge: -29299")
    end
  end
end
