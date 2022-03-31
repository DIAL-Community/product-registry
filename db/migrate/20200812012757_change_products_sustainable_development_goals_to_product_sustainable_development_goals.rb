# frozen_string_literal: true

class ChangeProductsSustainableDevelopmentGoalsToProductSustainableDevelopmentGoals < ActiveRecord::Migration[5.2]
  def change
    rename_table(:products_sustainable_development_goals, :product_sustainable_development_goals)
  end
end
