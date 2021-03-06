# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IdsDictionary::GetMaxReadingId, '#call' do
  include Dry::Monads[:result]

  let(:subject) { described_class }
  let(:token) { 'test_token' }

  before(:each) do
    Redis.current.flushall
  end

  context 'when collection is not created yet' do
    it 'returns 0 as max id' do
      result = subject.new.call

      expect(result).to eq Success(0)
    end
  end

  context 'when collection has 1 element' do
    it 'returns 1 as max id' do
      IdsDictionary::CalcNumberAndIdService.new(token).call

      result = subject.new.call

      expect(result).to eq Success(1)
    end
  end
end
