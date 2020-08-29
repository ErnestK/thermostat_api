# frozen_string_literal: true

module CacheReadings
  module WithRedisDataDeserialize
    def deserilialize_reading_value_from(str)
      return unless str

      hash = JSON.parse(str.gsub(':', '').gsub('=>', ':').gsub(':nil', ':null')).symbolize_keys

      ReadingValue.new(
        id: hash[:id],
        number: hash[:number],
        temperature: hash[:temperature],
        humidity: hash[:humidity],
        battery_charge: hash[:battery_charge],
        household_token: hash[:household_token],
        updated_at: hash[:updated_at],
        created_at: hash[:created_at]
      )
    end
  end
end
