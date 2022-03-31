# frozen_string_literal: true

class Origin < ApplicationRecord
  belongs_to :organization, optional: true
  has_and_belongs_to_many :products, join_table: :products_origins
  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }

  def self_url(options = {})
    return "#{options[:api_path]}/#{options[:api_source]}?origins[]=#{slug}" if options[:api_path].present?
  end

  def as_json(options = {})
    json = super(options)
    json['self_url'] = self_url(options)
    json
  end
end
