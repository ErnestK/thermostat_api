# frozen_string_literal: true

class ProcessReadingWorker
  include Sidekiq::Worker

  def perform(id)
    CreateReadingService.new(id).call
  end
end
