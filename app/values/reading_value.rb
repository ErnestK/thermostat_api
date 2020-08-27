# frozen_string_literal: true

class ReadingValue < Struct.new(:temperature, :humidity, :battery_charge, :household_token,
                                :id, :number, :updated_at, :created_at,
                                keyword_init: true)
end
