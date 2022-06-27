# frozen_string_literal: true
class AddFieldsToDatasets < ActiveRecord::Migration[5.2]
  def change
    add_column(:datasets, :license, :string)
    add_column(:datasets, :languages, :string)
    add_column(:datasets, :data_format, :string)
  end
end
