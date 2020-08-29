# frozen_string_literal: true

FactoryBot.define do
  factory :thermostat do
    household_token { '1' }
    location { 'baker street 1, apt 3' }
    created_at       { Time.now }
    updated_at       { Time.now }
  end
end
