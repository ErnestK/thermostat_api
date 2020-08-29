# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindReadingService, '#call' do
  include Dry::Monads[:result]

  let(:subject) { described_class }
  let(:reading_id) { 1 }

  before(:each) do
    Redis.current.flushall
  end

  context 'when exist in db' do
    it 'return reading wrapped in Success' do
      reading = create(:reading, id: reading_id)

      result = subject.new(reading_id).call

      expect(result).to eq Success(reading)
    end
  end

  context 'when not exist in db' do
    it 'return message wrapped in Failure' do
      result = subject.new(reading_id).call

      expect(result).to eq Failure("Cant find reading with id: #{reading_id}")
    end
  end
end
