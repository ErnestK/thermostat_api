# frozen_string_literal: true

class ProcessReadingWorker
  include Sidekiq::Worker

  def perform(id)
    AddReadingService.new(id).call
  end
end
