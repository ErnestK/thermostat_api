# frozen_string_literal: true

class StatsSerializer
  include FastJsonapi::ObjectSerializer
  attributes :avg_temperature, :min_temperature, :max_temperature,
             :avg_humidity, :min_humidity, :max_humidity,
             :avg_battery_charge, :min_battery_charge, :max_battery_charge
end
