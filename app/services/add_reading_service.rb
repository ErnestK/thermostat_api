# frozen_string_literal: true

class AddReadingService
  extend  Dry::Initializer
  include Dry::Monads[:result]

  param :reading_id

  def call
    CacheReadings::GetService.new(@reading_id).call.bind do |reading_value_from_cache|
      ValidateReadingService.new(reading_value_from_cache).call.bind do
        StatDictionary::AddService.new(reading_value_from_cache).call.bind do
          write_reading_db(reading_value_from_cache)
        end
      end
    end
  end

  private

  def write_reading_db(reading_value_from_cache)
    Reading.create(
      id: reading_value_from_cache.id,
      number: reading_value_from_cache.number,
      thermostat_id: Thermostat.find_by(household_token: reading_value_from_cache.household_token).id,
      temperature: reading_value_from_cache.temperature,
      humidity: reading_value_from_cache.humidity,
      battery_charge: reading_value_from_cache.battery_charge
    )

    Success(true)
  rescue StandardError => ex
    Failure("Exception, during write data to DB: #{ex.message}")
  end
end
