# frozen_string_literal: true

class DefferedCreateReadingService
  extend  Dry::Initializer
  include Dry::Monads[:result]

  opstion :temperature
  opstion :humidity
  opstion :battery
  opstion :household_token

  def call
    IdsDictionary::CalcNumberAndIdService.new(@household_token).call.bind do |id, number|
      reading_value(id, number).bind do |reading_value|
        CacheReadings::PushService.new(reading_value(params, id, number)).call.bind do
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
        @temperature,
        @humidity,
        @battery,
        @household_token,
        id,
        number
      )
    )
  end
end
