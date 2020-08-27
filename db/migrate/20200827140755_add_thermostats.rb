# frozen_string_literal: true

class AddThermostats < ActiveRecord::Migration[6.0]
  def change
    create_table :thermostats do |t|
      t.string :household_token
      t.text :location

      t.timestamps
    end
  end
end
