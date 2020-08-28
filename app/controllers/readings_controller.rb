# frozen_string_literal: true

class ReadingsController < ApplicationController
  def create
    params.require(:household_token)
    params.permit(:temperature, :humidity, :battery, :household_token)

    id, number = IdsDictionary::CalcNumberAndIDService.new(params.permit(:household_token)[:household_token]).call.value!

    reading_value = ReadingValue.new(
      params.permit(:temperature, :humidity, :battery, :household_token)
            .merge(id: id)
            .merge(number: number)
    )

    CacheReadings::PushService.new(reading_value).call
    ProcessReadingWorker.perform_async(id)

    render_monads serializer: CreateReadingSerializer, data: reading_value
  end

  def show
    params.require(:id)

    render_monads serializer: ReadingSerializer, data: FindReadingService.new(params.permit(:id)[:id]).call
  end
end
