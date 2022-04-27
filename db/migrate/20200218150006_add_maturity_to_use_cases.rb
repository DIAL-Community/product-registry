# frozen_string_literal: true

class AddMaturityToUseCases < ActiveRecord::Migration[5.1]
  def change
    add_column(:use_cases, :maturity, :string, default: 'Beta')

    add_column(:products_sustainable_development_goals, :link_type, :string)
  end
end
