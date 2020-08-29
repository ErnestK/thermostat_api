# frozen_string_literal: true

class ReadingsController < ApplicationController
  def create
    params.require(:household_token)
    params.permit(:temperature, :humidity, :battery_charge, :household_token)

    hash_params = {
      temperature: params[:temperature],
      humidity: params[:humidity],
      battery_charge: params[:battery_charge],
      household_token: params[:household_token]
    }
    reading_value = DefferedCreateReadingService.new(hash_params).call

    render_monads serializer: CreateReadingSerializer, data: reading_value
  end

  def show
    params.require(:id)

    render_monads serializer: ReadingSerializer, data: FindReadingService.new(params.permit(:id)[:id]).call
  end
end
