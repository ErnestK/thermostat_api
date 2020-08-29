# frozen_string_literal: true

module CacheReadings
  class PushService
    extend  Dry::Initializer
    include Dry::Monads[:result]
    include ::WithRedisNaming

    param :reading_value

    def call
      Success(
        Redis.current.hset(
          cache_readings_collection_name, reading_value.id, reading_value.to_h.transform_keys(&:to_s)
        )
      )
    end
  end
end
