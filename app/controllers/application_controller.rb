# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def render_monads(serializer:, data:)
    if data.success?
      render json: serializer.new(data.success).serialized_json
    else
      render json: ::FailureSerializer.new(FailureValue.new(message: data.failure)).serialized_json,
             status: :bad_request
    end
  end
end
