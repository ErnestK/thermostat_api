# frozen_string_literal: true

class CreateReadingSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :number
end
