# frozen_string_literal: true

module StatDictionary
  class AggregateReadingsService
    extend  Dry::Initializer
    include Dry::Monads[:result]
    include ::WithRedisNaming

    param :reading_value
    param :stat_dictionary_value

    def call
      Success(
        StatDictionaryValue.new(
          min_temperature: [@stat_dictionary_value.min_temperature, @reading_value.temperature.to_f].compact.min,
          max_temperature: [@stat_dictionary_value.max_temperature, @reading_value.temperature.to_f].compact.max,
          avg_temperature: avg_using(@stat_dictionary_value.avg_temperature.to_f, @reading_value.temperature.to_f),
          min_humidity: [@stat_dictionary_value.min_humidity, @reading_value.humidity.to_f].compact.min,
          max_humidity: [@stat_dictionary_value.max_humidity, @reading_value.humidity.to_f].compact.max,
          avg_humidity: avg_using(@stat_dictionary_value.avg_humidity.to_f, @reading_value.humidity.to_f),
          min_battery_charge: [@stat_dictionary_value.min_battery_charge, @reading_value.battery_charge.to_f].compact.min,
          max_battery_charge: [@stat_dictionary_value.max_battery_charge, @reading_value.battery_charge.to_f].compact.max,
          avg_battery_charge: avg_using(@stat_dictionary_value.avg_battery_charge.to_f, @reading_value.battery_charge.to_f),
          count: @stat_dictionary_value.count + 1,
          last_id: @stat_dictionary_value.last_id
        )
      )
    rescue StandardError => e
      Failure("Exception, during agg data stats dictionary: #{e.message}")
    end

    private

    def avg_using(prev_avg_value, next_avg_value)
      (prev_avg_value * @stat_dictionary_value.count + next_avg_value) / (@stat_dictionary_value.count + 1)
    end
  end
end
