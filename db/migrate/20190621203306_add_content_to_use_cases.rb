# frozen_string_literal: true

class AddContentToUseCases < ActiveRecord::Migration[5.1]
  def change
    remove_column(:use_cases, :description, :string)

    add_column(:use_cases, :description, :jsonb, null: false, default: '{}')
  end
end
