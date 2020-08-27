# frozen_string_literal: true

class AddReadingService
  extend  Dry::Initializer
  include Dry::Monads[:result]

  MIN_TEMPERATURE = -200
  MAX_TEMPERATURE = 200

  MIN_HUMIDITY = -100
  MAX_HUMIDITY = 100

  MIN_BATTERY_CHARGE = 0
  MAX_BATTERY_CHARGE = 100

  param :reading_value

  def call
    validate_data.bind do
      write_to_db
    end
  end

  private

  def validate_data
    validate_thermostat.bind do
      validate_temperature.bind do
        validate_humidity.bind do
          validate_battery_charge.bind do
            Success(true)
          end
        end
      end
    end
  end

  def validate_thermostat
    if Thermostat.exists?(household_token: @reading_value.household_token)
      Success(true)
    else
      Failure("Thermostat with that token no found, missing household_token: #{@reading_value.household_token}")
    end
  end

  def validate_temperature
    if @reading_value.temperature.to_f >= MIN_TEMPERATURE && @reading_value.temperature.to_f <= MAX_TEMPERATURE
      Success(true)
    else
      Failure("Temperature must be between #{MIN_TEMPERATURE} and #{MAX_TEMPERATURE}, corrupt temperature: #{@reading_value.temperature}")
    end
  end

  def validate_humidity
    if @reading_value.humidity.to_f >= MIN_HUMIDITY && @reading_value.humidity.to_f <= MAX_HUMIDITY
      Success(true)
    else
      Failure("Humidity charge must be between #{MIN_HUMIDITY} and #{MAX_HUMIDITY}, corrupt humidity: #{@reading_value.humidity}")
    end
  end

  def validate_battery_charge
    if @reading_value.battery_charge.to_f >= MIN_BATTERY_CHARGE && @reading_value.battery_charge.to_f <= MAX_BATTERY_CHARGE
      Success(true)
    else
      Failure("Battery charge must be between #{MIN_BATTERY_CHARGE} and #{MAX_BATTERY_CHARGE}, corrupt battery charge: #{@reading_value.battery_charge}")
    end
  end

  def write_to_db
    Reading.create(
      id: @reading_value.id,
      number: @reading_value.number,
      thermostat_id: Thermostat.find_by(household_token: @reading_value.household_token).id,
      temperature: @reading_value.temperature,
      humidity: @reading_value.humidity,
      battery_charge: @reading_value.battery_charge
    )

    Success(true)
  rescue StandardError => ex
    Failure("Exception, during write data to DB: #{ex.message}")
  end
end
