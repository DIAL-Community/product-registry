# frozen_string_literal: true

class AddCountryIdToAggregatorCapabilities < ActiveRecord::Migration[5.2]
  def change
    add_reference(:aggregator_capabilities, :country, foreign_key: true)
  end
end
