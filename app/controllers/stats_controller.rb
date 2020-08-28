# frozen_string_literal: true

class StatsController < ApplicationController
  def index
    render json: ::StatsSerializer.new(StatDictionary::GetAllService.new.call).serialized_json
  end
end
