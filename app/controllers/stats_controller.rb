# frozen_string_literal: true

class StatsController < ApplicationController
  def index
    render_monads serializer: StatsSerializer, data: GetAllStatService.new.call
  end
end
