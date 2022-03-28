# frozen_string_literal: true

class OperatorService < ActiveRecord::Base
  belongs_to :country

  attr_accessor :country_list

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }

  def self.to_csv
    attributes = %w[id name country service]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |op_service|
        csv << [op_service.id, op_service.name, op_service.location.name, op_service.service]
      end
    end
  end
end
