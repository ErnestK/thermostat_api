# frozen_string_literal: true

module StatDictionary
  class GetAllService
    extend  Dry::Initializer
    include Dry::Monads[:result]
    include ::WithRedisNaming

    def call
      Success(
        StatDictionaryValue.new(
          min_temperature: Redis.current.hget(dict_collection_name, :min_temperature)&.to_f,
          max_temperature: Redis.current.hget(dict_collection_name, :max_temperature)&.to_f,
          avg_temperature: Redis.current.hget(dict_collection_name, :avg_temperature)&.to_f,
          min_humidity: Redis.current.hget(dict_collection_name, :min_humidity)&.to_f,
          max_humidity: Redis.current.hget(dict_collection_name, :max_humidity)&.to_f,
          avg_humidity: Redis.current.hget(dict_collection_name, :avg_humidity)&.to_f,
          min_battery_charge: Redis.current.hget(dict_collection_name, :min_battery_charge)&.to_f,
          max_battery_charge: Redis.current.hget(dict_collection_name, :max_battery_charge)&.to_f,
          avg_battery_charge: Redis.current.hget(dict_collection_name, :avg_battery_charge)&.to_f,
          count: Redis.current.hget(dict_collection_name, :count).to_i,
          last_id: Redis.current.hget(dict_collection_name, :last_id).to_i
        )
      )
    rescue StandardError => e
      Failure("Exception, during added data to stats dictionary: #{e.message}")
    end
  end
end
