# frozen_string_literal: true

class AddReadingService
  extend  Dry::Initializer
  include Dry::Monads[:result]

  param :reading_value

  def call
    ValidateReadingService.new(reading_value).call.bind do
      RefreshStatDictionaryService.new(reading_value).call.bind do
        write_reading_db
      end
    end
  end

  private

  def write_reading_db
    Reading.create(
      id: @reading_value.id,
      number: @reading_value.number,
      thermostat_id: Thermostat.find_by(household_token: @reading_value.household_token).id,
      temperature: @reading_value.temperature,
      humidity: @reading_value.humidity,
      battery_charge: @reading_value.battery_charge
    )

    Success(true)
  rescue StandardError => ex
    Failure("Exception, during write data to DB: #{ex.message}")
  end
end
