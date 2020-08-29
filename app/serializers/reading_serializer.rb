# frozen_string_literal: true

class ReadingSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :number, :temperature, :humidity, :battery_charge
end
