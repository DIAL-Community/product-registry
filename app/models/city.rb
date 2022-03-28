# frozen_string_literal: true

class City < ApplicationRecord
  belongs_to :region

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }

  def to_param
    slug
  end

  def self_url(options = {})
    return "#{options[:api_path]}/cities/#{slug}" if options[:api_path].present?
    return options[:item_path] if options[:item_path].present?
    return "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/cities" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    return options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    return options[:item_path].sub("/cities/#{slug}", '') if options[:item_path].present?
    return options[:collection_path].sub('/cities', '') if options[:collection_path].present?
  end

  def as_json(options = {})
    json = super(options)
    json['region'] = region.as_json({ only: [:name] })
    if options[:include_relationships].present?
      offices = Office.where(city: name)
      json['organizations'] = offices.as_json({ only: %i[name slug website], api_path: api_path(options) })
    end
    json['self_url'] = self_url(options) if options[:collection_path].present? || options[:api_path].present?
    json['collection_url'] = collection_url(options) if options[:item_path].present?
    json
  end

  def self.serialization_options
    {
      except: %i[id region_id created_at updated_at]
    }
  end
end
