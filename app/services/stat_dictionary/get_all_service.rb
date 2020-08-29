# frozen_string_literal: true

module StatDictionary
  class GetAllService
    extend  Dry::Initializer
    include Dry::Monads[:result]
    include ::WithRedisNaming

    def call
      min_temperature, max_temperature, avg_temperature = Redis.current.hmget(dict_collection_name, :min_temperature, :max_temperature, :avg_temperature).compact.map(&:to_f)
      min_humidity, max_humidity, avg_humidity = Redis.current.hmget(dict_collection_name, :min_humidity, :max_humidity, :avg_humidity).compact.map(&:to_f)
      min_battery_charge, max_battery_charge, avg_battery_charge = Redis.current.hmget(dict_collection_name, :min_battery_charge, :max_battery_charge, :avg_battery_charge).compact.map(&:to_f)
      count, last_id = Redis.current.hmget(dict_collection_name, :count, :last_id).map(&:to_f)

      Success(
        StatDictionaryValue.new(
          min_temperature: min_temperature,
          max_temperature: max_temperature,
          avg_temperature: avg_temperature,
          min_humidity: min_humidity,
          max_humidity: max_humidity,
          avg_humidity: avg_humidity,
          min_battery_charge: min_battery_charge,
          max_battery_charge: max_battery_charge,
          avg_battery_charge: avg_battery_charge,
          count: count,
          last_id: last_id
        )
      )
    rescue StandardError => ex
      Failure("Exception, during added data to stats dictionary: #{ex.message}")
    end
  end
end
