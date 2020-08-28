# frozen_string_literal: true

module StatDictionary
  class GetAllService
    extend  Dry::Initializer
    include Dry::Monads[:result]

    def call
      Success(true)
    end
  end
end
