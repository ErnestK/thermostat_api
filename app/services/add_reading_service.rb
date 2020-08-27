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

  option :id
  option :number
  option :household_token
  option :temperature
  option :humidity
  option :battery_charge

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
    if Thermostat.exists?(household_token: @household_token)
      Success(true)
    else
      Failure("Thermostat with that token no found, missing household_token: #{@temperature}")
    end
  end

  def validate_temperature
    if battery_charge >= MIN_TEMPERATURE && battery_charge <= MAX_TEMPERATURE
      Success(true)
    else
      Failure("Temperature must be between #{MIN_TEMPERATURE} and #{MAX_TEMPERATURE}, corrupt temperature: #{@temperature}")
    end
  end

  def validate_humidity
    if battery_charge >= MIN_HUMIDITY && battery_charge <= MAX_HUMIDITY
      Success(true)
    else
      Failure("Humidity charge must be between #{MIN_HUMIDITY} and #{MAX_HUMIDITY}, corrupt humidity: #{@humidity}")
    end
  end

  def validate_battery_charge
    if battery_charge >= MIN_BATTERY_CHARGE && battery_charge <= MAX_BATTERY_CHARGE
      Success(true)
    else
      Failure("Battery charge must be between #{MIN_BATTERY_CHARGE} and #{MAX_BATTERY_CHARGE}, corrupt battery charge: #{@battery_charge}")
    end
  end

  def write_to_db
    Reading.create(
      id: @id,
      number: @number,
      thermostat_id: @thermostat_id,
      temperature: @temperature,
      humidity: @humidity,
      battery_charge: @battery_charge
    )

    Success(true)
  rescue ex
    Failure("Exception, during write data to DB: #{ex.message}")
  end
end
