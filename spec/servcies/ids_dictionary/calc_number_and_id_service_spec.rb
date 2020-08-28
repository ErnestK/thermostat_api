# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IdsDictionary::CalcNumberAndIdService, '#call' do
  include Dry::Monads[:result]

  let(:token) { 'test_token' }
  let(:diff_token) { 'diff_test_token' }

  before(:each) do
    Redis.current.flushall
  end

  context 'when dict not exist' do
    it 'create dict and return 1 as id and 1 as number in Success' do
      result = IdsDictionary::CalcNumberAndIdService.new(token).call

      expect(result).to eq Success([1, 1])
    end
  end

  context 'when call second times with different token' do
    it 'create dict and return 2 as id and 1 as number in Success' do
      result = IdsDictionary::CalcNumberAndIdService.new(token).call
      result = IdsDictionary::CalcNumberAndIdService.new(diff_token).call

      expect(result).to eq Success([2, 1])
    end
  end
end
