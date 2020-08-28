# frozen_string_literal: true

class FindReadingService
  extend  Dry::Initializer
  include Dry::Monads[:result]

  param :reading_id

  def call
    reading = find_in_cache || find_in_db
    reading.nil? ? Failure("Cant find reading with id: #{reading_id}") : Success(reading)
  end

  private

  def find_in_cache
    Cache::GetReadingService.new(reading_id).call
  end

  def find_in_db
    Reading.find_by(id: reading_id)
  end
end
