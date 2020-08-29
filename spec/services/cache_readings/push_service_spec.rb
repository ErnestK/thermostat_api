# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CacheReadings::PushService, '#call' do
  include Dry::Monads[:result]
  include ::WithRedisNaming

  let(:subject) { described_class }
  let(:reading_id) { 1 }
  let(:reading_value) {
    ReadingValue.new(
      id: reading_id,
      number: 1,
      household_token: '1',
      temperature: 1,
      humidity: 1,
      battery_charge: 1,
    )
  }

  before(:each) do
    Redis.current.flushall
  end

  it 'create row in redis collection' do
    result = subject.new(reading_value).call

    expect(result).to eq Success(1)
    expect(Redis.current.hlen(cache_readings_collection_name)).to eq 1
  end
end
