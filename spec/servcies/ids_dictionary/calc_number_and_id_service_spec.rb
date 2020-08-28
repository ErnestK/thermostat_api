# # frozen_string_literal: true

# module IdsDictionary
#   class CalcNumberAndIdService
#     extend  Dry::Initializer
#     include Dry::Monads[:result]
#     include ::WithRedisNaming

#     param :household_token

#     def call
#       GetMaxReadingId.new.call.bind do |last_id|
#         get_number_for_household_token.bind do |number|
#           increment_id_and_number(number, last_id)
#         end
#       end
#     end

#     private

#     def get_number_for_household_token
#       Redis.current.hget(ids_readings_collection_name, household_token.to_sym).map(&:to_i).first
#     end

#     def increment_id_and_number(number, last_id)
#       Redis.current.hmset(ids_readings_collection_name,
#         household_token.to_sym, number.to_i + 1,
#         :last_id, last_id.to_i + 1
#       )
#     end
#   end
# end

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
