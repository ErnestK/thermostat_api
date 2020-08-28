# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatDictionary::AddService, '#call' do
  include Dry::Monads[:result]
  include WithRedisNaming
  STAT_DICTIONARY_VALUE_KEYS = 11

  let(:reading_value) {
    ReadingValue.new(
      id: 1,
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

  context 'when call method' do
    it 'add to db STAT_DICTIONARY_VALUE_KEYS keys and return true in Success' do
      result = StatDictionary::AddService.new(reading_value).call

      expect(result).to eq Success(true)
      expect(Redis.current.hlen(dict_collection_name)).to eq STAT_DICTIONARY_VALUE_KEYS
    end
  end
end
