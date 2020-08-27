# frozen_string_literal: true

class StatsSerializer
  include FastJsonapi::ObjectSerializer
  attributes :average_temperature, :minimum_temperature, :maximum_temperature,
              :average_humidity, :minimum_humidity, :maximum_humidity,
              :average_battery_charge, :minimum_battery_charge, :maximum_battery_charge
end
