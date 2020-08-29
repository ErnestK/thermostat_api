# frozen_string_literal: true

module CacheReadings
  class GetAllService
    extend  Dry::Initializer
    include Dry::Monads[:result]
    include ::WithRedisNaming

    param :last_id
    param :max_id

    def call
      Success(
        (last_id.to_i + 1..max_id.to_i).map do |reading_id|
          str = Redis.current.hget(cache_readings_collection_name, reading_id)
          hash = JSON.parse(str.gsub(':', '').gsub('=>', ':').gsub(':nil', ':null')).symbolize_keys

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
        end
      )
    end
  end
end
