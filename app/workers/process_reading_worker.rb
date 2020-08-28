# frozen_string_literal: true

class ProcessReadingWorker
  include Sidekiq::Worker

  def perform(id)
    p id
  end
end
