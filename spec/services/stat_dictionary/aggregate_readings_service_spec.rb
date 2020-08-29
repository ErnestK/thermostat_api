# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatDictionary::AggregateReadingsService, '#call' do
  include Dry::Monads[:result]
  include WithRedisNaming

  let(:count) { 2.0 }

  let(:avg_temperature) { 7.0 }
  let(:avg_humidity) { 6.0 }
  let(:avg_battery_charge) { 6.0 }
  let(:subject) { described_class }

  let(:stat_dictionary_value) do
    StatDictionaryValue.new(
      min_temperature: 6.0,
      max_temperature: 8.0,
      avg_temperature: avg_temperature,
      min_humidity: 4.0,
      max_humidity: 8.0,
      avg_humidity: avg_humidity,
      min_battery_charge: 3.0,
      max_battery_charge: 9.0,
      avg_battery_charge: avg_battery_charge,
      count: count,
      last_id: 1.0
    )
  end

  let(:reading_value) do
    ReadingValue.new(
      id: 2,
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

  context "when reading value's temperature is bigger then max_temperature" do
    let(:bigger_temperature) { 200 }

    it 'changes max_temperature' do
      reading_value.temperature = bigger_temperature
      result = subject.new(reading_value, stat_dictionary_value).call

      expect(result.value!.max_temperature).to eq bigger_temperature
    end
  end

  context "when reading value's humudity is bigger then max_humudity" do
    let(:bigger_humidity) { 200 }

    it 'changes max_humudity' do
      reading_value.humidity = bigger_humidity
      result = subject.new(reading_value, stat_dictionary_value).call

      expect(result.value!.max_humidity).to eq bigger_humidity
    end
  end

  context "when reading value's battery_charge is bigger then max_battery_charge" do
    let(:bigger_battery_charge) { 200 }

    it 'changes max_battery_charge' do
      reading_value.battery_charge = bigger_battery_charge
      result = subject.new(reading_value, stat_dictionary_value).call

      expect(result.value!.max_battery_charge).to eq bigger_battery_charge
    end
  end

  context 'when pass reading value with temperature lt then min' do
    let(:lesser_temperature) { 1.0 }
    let(:reading_value) do
      ReadingValue.new(
        id: 2,
        number: 1,
        household_token: '1',
        temperature: lesser_temperature,
        humidity: 1,
        battery_charge: 1
      )
    end

    it 'changes min_temperature' do
      result = subject.new(reading_value, stat_dictionary_value).call

      expect(result.value!.min_temperature).to eq lesser_temperature
    end
  end

  context 'when pass reading value with humudity lt then min' do
    let(:lesser_humidity) { 1.0 }
    let(:reading_value) do
      ReadingValue.new(
        id: 2,
        number: 1,
        household_token: '1',
        temperature: 1,
        humidity: lesser_humidity,
        battery_charge: 1
      )
    end

    it 'changes min_humudity' do
      result = subject.new(reading_value, stat_dictionary_value).call

      expect(result.value!.min_humidity).to eq lesser_humidity
    end
  end

  context 'when pass reading value with battery_charge lt then min' do
    let(:lesser_battery_charge) { 1.0 }
    let(:reading_value) do
      ReadingValue.new(
        id: 2,
        number: 1,
        household_token: '1',
        temperature: 1,
        humidity: 1,
        battery_charge: lesser_battery_charge
      )
    end

    it 'changes min_battery_charge' do
      result = subject.new(reading_value, stat_dictionary_value).call

      expect(result.value!.min_battery_charge).to eq lesser_battery_charge
    end
  end
  ###

  context 'when passed reading value' do
    let(:temperature) { 3.0 }
    let(:humidity) { 7.0 }
    let(:battery_charge) { 13.0 }
    let(:reading_value) do
      ReadingValue.new(
        id: 2,
        number: 1,
        household_token: '1',
        temperature: temperature,
        humidity: humidity,
        battery_charge: battery_charge
      )
    end
    let(:result) { subject.new(reading_value, stat_dictionary_value).call }

    it 'recalculates avg_temperature' do
      expect_value = (temperature + avg_temperature * count) / (count + 1)

      expect(result.value!.avg_temperature).to eq expect_value
    end

    it 'recalculates avg_humudity' do
      expect_value = (humidity + avg_humidity * count) / (count + 1)

      expect(result.value!.avg_humidity).to eq expect_value
    end

    it 'recalculates avg_battery_charge' do
      expect_value = (battery_charge + avg_battery_charge * count) / (count + 1)

      expect(result.value!.avg_battery_charge).to eq expect_value
    end

    it 'returns StatDictionaryValue with incr count' do
      expect(result.value!.count).to eq count + 1
    end
  end
end
