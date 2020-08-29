# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CacheReadings::GetService, '#call' do
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

  it 'return row from redis as ReadingValue in Success' do
    CacheReadings::PushService.new(reading_value).call
    result = subject.new(reading_id).call

    expect(result).to eq Success(reading_value)
  end
end
