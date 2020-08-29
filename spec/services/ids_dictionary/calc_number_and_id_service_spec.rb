# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IdsDictionary::CalcNumberAndIdService, '#call' do
  include Dry::Monads[:result]

  let(:subject) { described_class }
  let(:token) { 'test_token' }
  let(:diff_token) { 'diff_test_token' }

  before(:each) do
    Redis.current.flushall
  end

  context 'when dict does not exist' do
    it 'creates dict and returns id = 1 and number = 1 in Success' do
      result = subject.new(token).call

      expect(result).to eq Success([1, 1])
    end
  end

  context 'when call second times with different token' do
    it 'creates dict and returns id = 2  and number = 1 in Success' do
      result = subject.new(token).call
      result = subject.new(diff_token).call

      expect(result).to eq Success([2, 1])
    end
  end
end
