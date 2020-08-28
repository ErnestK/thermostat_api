# frozen_string_literal: true

module Cache
  class GetReadingService
    extend  Dry::Initializer
    include Dry::Monads[:result]

    def call
      Success(true)
    end
  end
end