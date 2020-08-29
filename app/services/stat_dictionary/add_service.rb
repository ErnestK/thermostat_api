# frozen_string_literal: true

module StatDictionary
  class AddService
    extend  Dry::Initializer
    include Dry::Monads[:result]
    include ::WithRedisNaming

    param :reading_value

    def call
      GetAllService.new.call.bind do |stat_dictionary_value|
        AggregateReadingsService.new(reading_value, stat_dictionary_value).call.bind do |agg_stat_dictionary_value|
          write_to_dict(agg_stat_dictionary_value)
        end
      end
    rescue StandardError => e
      Failure("Exception, during added data to stats dictionary: #{e.message}")
    end

    private

    def write_to_dict(stat_dictionary_value)
      Redis.current.hmset(
        dict_collection_name,
        :min_temperature,
        stat_dictionary_value.min_temperature,
        :max_temperature,
        stat_dictionary_value.max_temperature,
        :avg_temperature,
        stat_dictionary_value.avg_temperature,
        :min_humidity,
        stat_dictionary_value.min_humidity,
        :max_humidity,
        stat_dictionary_value.max_humidity,
        :avg_humidity,
        stat_dictionary_value.avg_humidity,
        :min_battery_charge,
        stat_dictionary_value.min_battery_charge,
        :max_battery_charge,
        stat_dictionary_value.max_battery_charge,
        :avg_battery_charge,
        stat_dictionary_value.avg_battery_charge,
        :count,
        stat_dictionary_value.count,
        :last_id,
        @reading_value.id
      )

      Success(true)
    end
  end
end
