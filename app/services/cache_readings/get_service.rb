# frozen_string_literal: true

module CacheReadings
  class GetService
    extend  Dry::Initializer
    include Dry::Monads[:result]
    include ::WithRedisNaming
    include WithRedisDataDeserialize

    param :reading_id

    def call
      str = Redis.current.hget(cache_readings_collection_name, reading_id)
      return Success(nil) unless str

      Success(deserilialize_reading_value_from(str))
    end
  end
end
