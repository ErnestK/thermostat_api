# frozen_string_literal: true

class FindReadingService
  extend  Dry::Initializer
  include Dry::Monads[:result]

  param :reading_id

  def call
    CacheReadings::GetService.new(reading_id).call.bind do |data_from_cache|
      reading = data_from_cache || Reading.find_by(id: reading_id)

      reading.nil? ? Failure("Cant find reading with id: #{reading_id}") : Success(reading)
    end
  end
end
