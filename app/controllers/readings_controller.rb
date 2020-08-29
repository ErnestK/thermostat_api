# frozen_string_literal: true

class ReadingsController < ApplicationController
  def create
    params.require(:household_token)
    params.permit(:temperature, :humidity, :battery, :household_token)

    reading_value = DefferedCreateReadingService.new(params.permit(:temperature, :humidity, :battery, :household_token))
                                                .call

    render_monads serializer: CreateReadingSerializer, data: reading_value
  end

  def show
    params.require(:id)

    render_monads serializer: ReadingSerializer, data: FindReadingService.new(params.permit(:id)[:id]).call
  end
end
