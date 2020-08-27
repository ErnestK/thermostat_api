# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

thermostat_1 = Thermostat.create(household_token: '1', location: 'baker street 1, apt 1')
Thermostat.create(household_token: '2', location: 'baker street 1, apt 2')
Thermostat.create(household_token: '3', location: 'baker street 1, apt 3')

AddReadingService.new(
  ReadingValue.new(
    id: 1,
    number: 1,
    household_token: thermostat_1.household_token,
    temperature: '6',
    humidity: '78',
    battery_charge: '12'
  )
).call
