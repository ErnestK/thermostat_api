# frozen_string_literal: true

class GetAllStatService
  extend  Dry::Initializer
  include Dry::Monads[:result]

  def call
    StatDictionary::GetAllService.new.call.bind do |stat_dictionary_value|
      IdsDictionary::GetMaxReadingId.new.call.bind do |max_reading_id|
        CacheReadings::GetAllService.new(stat_dictionary_value.last_id, max_reading_id).call.bind do |cached_readings|
          cached_readings.map do |cached_reading|
            stat_dictionary_value = StatDictionary::AggregateReadingsService.new(cached_reading, stat_dictionary_value)
                                                                            .call
                                                                            .value!
          end

          Success(stat_dictionary_value)
        end
      end
    end
  end
end
