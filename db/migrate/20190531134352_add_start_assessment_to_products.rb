# frozen_string_literal: true

class AddStartAssessmentToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :start_assessment, :boolean
  end
end
