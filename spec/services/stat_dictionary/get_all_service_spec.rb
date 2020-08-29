# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatDictionary::GetAllService, '#call' do
  include Dry::Monads[:result]

  let(:subject) { described_class }

  before(:each) do
    Redis.current.flushall
  end

  context 'when stats data is not empty' do
    let(:expected_stat_dictionary_value) {
      StatDictionaryValue.new(
        min_temperature: 0.0,
        max_temperature: 4.0,
        avg_temperature: 4.0,
        min_humidity: 0.0,
        max_humidity: 8.0,
        avg_humidity: 8.0,
        min_battery_charge: 0.0,
        max_battery_charge: 9.0,
        avg_battery_charge: 9.0,
        count: 1.0,
        last_id: 1.0
      )
    }

    let(:reading_value) {
      ReadingValue.new(
        id: 1,
        number: 2,
        household_token: 1,
        temperature: 4,
        humidity: 8,
        battery_charge: 9,
      )
    }

    it 'returns expected stats data as StatDictionaryValue' do
      StatDictionary::AddService.new(reading_value).call
      result = subject.new.call

      expect(result).to eq Success(expected_stat_dictionary_value)
    end
  end

  context 'when stats data is empty' do
    let(:expected_empty_stat_dictionary_value) {
      StatDictionaryValue.new(
        min_temperature: 0.0,
        max_temperature: 0.0,
        avg_temperature: 0.0,
        min_humidity: 0.0,
        max_humidity: 0.0,
        avg_humidity: 0.0,
        min_battery_charge: 0.0,
        max_battery_charge: 0.0,
        avg_battery_charge: 0.0,
        count: 0.0,
        last_id: 0.0
      )
    }

    it 'returns zero object in Success as StatDictionaryValue' do
      result = subject.new.call

      expect(result).to eq Success(expected_empty_stat_dictionary_value)
    end
  end
end
