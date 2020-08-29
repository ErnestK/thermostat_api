# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatDictionary::GetAllService, '#call' do
  include Dry::Monads[:result]

  let(:subject) { described_class }

  let(:temperature) { 42.0 }
  let(:humudity) { 43.0 }
  let(:battery_charge) { 13.0 }

  before(:each) do
    Redis.current.flushall
  end

  context 'when stats data is not empty' do
    let(:expected_stat_dictionary_value) do
      StatDictionaryValue.new(
        min_temperature: temperature,
        max_temperature: temperature,
        avg_temperature: temperature,
        min_humidity: humudity,
        max_humidity: humudity,
        avg_humidity: humudity,
        min_battery_charge: battery_charge,
        max_battery_charge: battery_charge,
        avg_battery_charge: battery_charge,
        count: 1.0,
        last_id: 1.0
      )
    end

    let(:reading_value) do
      ReadingValue.new(
        id: 1,
        number: 2,
        household_token: 1,
        temperature: temperature,
        humidity: humudity,
        battery_charge: battery_charge
      )
    end

    it 'returns expected stats data as StatDictionaryValue' do
      StatDictionary::AddService.new(reading_value).call
      result = subject.new.call

      expect(result).to eq Success(expected_stat_dictionary_value)
    end
  end

  context 'when stats data is empty' do
    let(:expected_empty_stat_dictionary_value) do
      StatDictionaryValue.new(
        min_temperature: nil,
        max_temperature: nil,
        avg_temperature: nil,
        min_humidity: nil,
        max_humidity: nil,
        avg_humidity: nil,
        min_battery_charge: nil,
        max_battery_charge: nil,
        avg_battery_charge: nil,
        count: 0.0,
        last_id: 0.0
      )
    end

    it 'returns nil object in Success as StatDictionaryValue' do
      result = subject.new.call

      expect(result).to eq Success(expected_empty_stat_dictionary_value)
    end
  end
end
