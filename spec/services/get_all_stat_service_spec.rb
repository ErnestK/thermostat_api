# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GetAllStatService, '#call' do
  include Dry::Monads[:result]

  let(:subject) { described_class }

  let(:household_token) { 'test_token' }

  before(:each) do
    Redis.current.flushall
  end

  let(:higher_temperature) { 42.0 }
  let(:lower_temperature) { 13.0 }
  let(:higher_humudity) { 43.0 }
  let(:lower_humudity) { 12.0 }
  let(:higher_battery_charge) { 44.0 }
  let(:lower_battery_charge) { 11.0 }

  let(:expected_stat_dictionary_value) do
    StatDictionaryValue.new(
      id: nil,
      count: 2,
      last_id: 1,
      avg_temperature: (lower_temperature + higher_temperature) / 2,
      min_temperature: lower_temperature,
      max_temperature: higher_temperature,
      avg_humidity: (lower_humudity + higher_humudity) / 2,
      min_humidity: lower_humudity,
      max_humidity: higher_humudity,
      avg_battery_charge: (lower_battery_charge + higher_battery_charge) / 2,
      min_battery_charge: lower_battery_charge,
      max_battery_charge: higher_battery_charge
    )
  end

  context 'when exist in db' do
    it 'return reading wrapped in Success' do
      create_row_in_db
      create_row_in_cache
      result = subject.new.call

      expect(result).to eq Success(expected_stat_dictionary_value)
    end

    def create_row_in_db
      create(:thermostat, household_token: household_token)
      id, number = IdsDictionary::CalcNumberAndIdService.new(household_token).call.value!
      reading_value_db = ReadingValue.new(
        id: id,
        number: number,
        household_token: household_token,
        temperature: higher_temperature,
        humidity: higher_humudity,
        battery_charge: higher_battery_charge
      )

      CacheReadings::PushService.new(reading_value_db).call
      CreateReadingService.new(id).call
    end

    def create_row_in_cache
      id, number = IdsDictionary::CalcNumberAndIdService.new(household_token).call.value!
      reading_value_cache = ReadingValue.new(
        id: id,
        number: number,
        household_token: household_token,
        temperature: lower_temperature,
        humidity: lower_humudity,
        battery_charge: lower_battery_charge
      )
      CacheReadings::PushService.new(reading_value_cache).call
    end
  end
end
