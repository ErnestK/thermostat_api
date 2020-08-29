# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

thermostat = Thermostat.create(household_token: '1', location: 'baker street 1, apt 1')
Thermostat.create(household_token: '2', location: 'baker street 1, apt 2')
Thermostat.create(household_token: '3', location: 'baker street 1, apt 3')

DefferedCreateReadingService.new(1, 1, 1, thermostat.household_token).call
