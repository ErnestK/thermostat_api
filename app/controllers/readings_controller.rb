# frozen_string_literal: true

class ReadingsController < ApplicationController
  def create
    params.require(:household_token)
    params.permit(:temperature, :humidity, :battery, :household_token)

    id, number = CalcNumberAndIDService.new(params.permit(:household_token)).call

    reading_value = ReadingValue.new(
      params.permit(:temperature, :humidity, :battery, :household_token)
            .merge(id: id)
            .merge(number: number)
    )

    PushToReadingCacheService.new(reading_value).call
    ProcessReadingWorker.perform_async(id)

    render json: ::CreateReadingSerializer.new(reading_value).serialized_json
  end

  def show
    params.require(:id)

    render json: ::ReadingSerializer.new(FindReadingService.new(params.permit(:id)).call).serialized_json
  end
end
