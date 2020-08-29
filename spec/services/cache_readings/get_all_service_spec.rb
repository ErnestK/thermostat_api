# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CacheReadings::GetAllService, '#call' do
  include Dry::Monads[:result]
  include ::WithRedisNaming

  let(:subject) { described_class }

  let(:last_id) { 0 }
  let(:max_id) { 3 }
  let(:valid_reading_value_1) do
    ReadingValue.new(
      id: 1,
      number: 1,
      household_token: '1',
      temperature: 1,
      humidity: 1,
      battery_charge: 1,
    )
  end

  let(:valid_reading_value_2) do
    ReadingValue.new(
      id: 2,
      number: 2,
      household_token: '2',
      temperature: 2,
      humidity: 2,
      battery_charge: 2,
    )
  end

  let(:valid_reading_value_3) do
    ReadingValue.new(
      id: 3,
      number: 3,
      household_token: '3',
      temperature: 3,
      humidity: 3,
      battery_charge: 3,
    )
  end

  before(:each) do
    Redis.current.flushall
  end

  it 'select all elements from cache in period ids and wrap into value' do
    CacheReadings::PushService.new(valid_reading_value_1).call
    CacheReadings::PushService.new(valid_reading_value_2).call
    CacheReadings::PushService.new(valid_reading_value_3).call

    result = subject.new(last_id, max_id).call

    expect(result.value!.size).to eq 3
    expect(result.value!.first).to eq valid_reading_value_1
    expect(result.value!.second).to eq valid_reading_value_2
    expect(result.value!.last).to eq valid_reading_value_3
  end
end
