# frozen_string_literal: true

ReadingValue = Struct.new(:temperature, :humidity, :battery_charge, :household_token,
                          :id, :number, :updated_at, :created_at,
                          keyword_init: true) do
end
