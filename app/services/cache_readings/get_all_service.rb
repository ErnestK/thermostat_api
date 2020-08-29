# frozen_string_literal: true

module CacheReadings
  class GetAllService
    extend  Dry::Initializer
    include Dry::Monads[:result]
    include ::WithRedisNaming
    include WithRedisDataDeserialize

    param :last_id
    param :max_id

    def call
      cached_readings = (last_id.to_i + 1..max_id.to_i).map do |reading_id|
        deserilialize_reading_value_from Redis.current.hget(cache_readings_collection_name, reading_id)
      end

      Success(cached_readings)
    end
  end
end
