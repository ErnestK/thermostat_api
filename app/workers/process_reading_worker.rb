# frozen_string_literal: true

class ProcessReadingWorker
  include Sidekiq::Worker

  def perform(id)
    result = CreateReadingService.new(id).call
    logger.error result.failure if result.failure?
  end
end
