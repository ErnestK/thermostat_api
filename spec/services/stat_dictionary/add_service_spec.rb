# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatDictionary::AddService, '#call' do
  include Dry::Monads[:result]
  include WithRedisNaming
  STAT_DICTIONARY_VALUE_ATTR_COUNT = 11

  let(:subject) { described_class }
  let(:reading_value) do
    ReadingValue.new(
      id: 1,
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

  it 'adds to db all reading_value params and returns Success' do
    result = subject.new(reading_value).call

    expect(result).to eq Success(true)
    expect(Redis.current.hlen(dict_collection_name)).to eq STAT_DICTIONARY_VALUE_ATTR_COUNT
  end
end
