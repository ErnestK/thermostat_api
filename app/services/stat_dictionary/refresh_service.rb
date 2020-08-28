# frozen_string_literal: true

module StatDictionary
  class RefreshService
    extend  Dry::Initializer
    include Dry::Monads[:result]

    def call
      Success(true)
    end
  end
end
