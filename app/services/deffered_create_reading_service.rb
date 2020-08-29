# frozen_string_literal: true

class DefferedCreateReadingService
  extend  Dry::Initializer
  include Dry::Monads[:result]

  option :temperature
  option :humidity
  option :battery_charge
  option :household_token

  def call
    IdsDictionary::CalcNumberAndIdService.new(@household_token).call.bind do |id, number|
      reading_value(id, number).bind do |reading_value|
        CacheReadings::PushService.new(reading_value).call.bind do
          ProcessReadingWorker.perform_async(id)
          Success(reading_value)
        end
      end
    end
  end

  private

  def reading_value(id, number)
    Success(
      ReadingValue.new(
        temperature: @temperature,
        humidity: @humidity,
        battery_charge: @battery_charge,
        household_token: @household_token,
        id: id,
        number: number
      )
    )
  end
end
