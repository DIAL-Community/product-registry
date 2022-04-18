# frozen_string_literal: true

class AddCountryIdToOperatorServices < ActiveRecord::Migration[5.2]
  def change
    add_reference(:operator_services, :country, foreign_key: true)
    add_column(:operator_services, :country_name, :string)
  end
end
