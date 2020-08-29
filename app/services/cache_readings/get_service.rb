# frozen_string_literal: true

module CacheReadings
  class GetService
    extend  Dry::Initializer
    include Dry::Monads[:result]
    include ::WithRedisNaming

    param :reading_id

    def call
      str = Redis.current.hget(cache_readings_collection_name, reading_id)
      return Success(nil) unless str

      hash = JSON.parse(str.gsub(':', '').gsub('=>', ':').gsub(':nil', ':null')).symbolize_keys

      Success(
        ReadingValue.new(
          id: hash[:id],
          number: hash[:number],
          temperature: hash[:temperature],
          humidity: hash[:humidity],
          battery_charge: hash[:battery_charge],
          household_token: hash[:household_token],
          updated_at: hash[:updated_at],
          created_at: hash[:created_at]
        )
      )
    end
  end
end
