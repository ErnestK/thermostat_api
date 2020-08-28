# frozen_string_literal: true

class FailureSerializer
  include FastJsonapi::ObjectSerializer

  attributes :message
end
