# frozen_string_literal: true

class CalcNumberAndIdService
  extend  Dry::Initializer
  include Dry::Monads[:result]

  def call
    Success(true)
  end
end
