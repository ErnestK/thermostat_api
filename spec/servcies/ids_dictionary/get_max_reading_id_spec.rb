# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IdsDictionary::GetMaxReadingId, '#call' do
  include Dry::Monads[:result]

  let(:token) { 'test_token' }

  before(:each) do
    Redis.current.flushall
  end

  context 'when no collection' do
    it 'return 0 as max id' do
      result = IdsDictionary::GetMaxReadingId.new.call

      expect(result).to eq Success(0)
    end
  end

  context 'when collection has 1 elemnt' do
    it 'return 1 as max id' do
      IdsDictionary::CalcNumberAndIdService.new(token).call

      result = IdsDictionary::GetMaxReadingId.new.call

      expect(result).to eq Success(1)
    end
  end
end
