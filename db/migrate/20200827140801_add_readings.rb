# frozen_string_literal: true

class AddReadings < ActiveRecord::Migration[6.0]
  def change
    create_table :readings do |t|
      t.integer :number
      t.decimal :temperature
      t.decimal :humidity
      t.decimal :battery_charge

      t.timestamps
    end

    add_reference :readings, :thermostat, foreign_key: true
  end
end
