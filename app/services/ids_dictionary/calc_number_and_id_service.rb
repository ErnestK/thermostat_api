# frozen_string_literal: true

module IdsDictionary
  class CalcNumberAndIdService
    extend  Dry::Initializer
    include Dry::Monads[:result]
    include ::WithRedisNaming

    param :household_token

    def call
      GetMaxReadingId.new.call.bind do |last_id|
        get_number_for_household_token.bind do |number|
          increment_id_and_number(number, last_id).bind do
            Success([last_id + 1, number + 1])
          end
        end
      end
    end

    private

    def get_number_for_household_token
      Success(Redis.current.hget(ids_readings_collection_name, household_token.to_sym).to_i)
    end

    def increment_id_and_number(number, last_id)
      Success(
        Redis.current.hmset(ids_readings_collection_name,
                            household_token.to_sym, number.to_i + 1,
                            :last_id, last_id.to_i + 1)
      )
    end
  end
end
