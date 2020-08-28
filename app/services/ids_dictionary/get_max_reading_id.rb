# frozen_string_literal: true

module IdsDictionary
  class GetMaxReadingId
    extend  Dry::Initializer
    include Dry::Monads[:result]
    include ::WithRedisNaming

    def call
      Success(Redis.current.hget(ids_readings_collection_name, :last_id).to_i)
    end
  end
end
