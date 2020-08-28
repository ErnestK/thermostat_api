# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddReadingService, '#call' do
  include Dry::Monads[:result]

  let(:valid_reading_value) do
    ReadingValue.new(
      id: 1,
      number: 1,
      household_token: '1',
      temperature: 1,
      humidity: 1,
      battery_charge: 1,
    )
  end

  context 'when all data is correct' do
    it 'Add new data in table' do
      create(:thermostat)

      result = AddReadingService.new(valid_reading_value).call

      expect(result).to eq Success(true)
      expect(Reading.count).to eq 1
    end
  end
end
