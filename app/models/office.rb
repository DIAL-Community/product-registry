# frozen_string_literal: true

class Office < ApplicationRecord
  include Modules::Slugger

  belongs_to :organization
  belongs_to :country
  belongs_to :region

  def office_country
    country = Country.find_by(id: country_id) unless country_id.nil?
    country
  end

  def office_region
    region_name = Region.find_by(id: region_id).name unless region_id.nil?
    region_name
  end

  def self_url(options = {})
    record = City.find_by(name: city)
    return "#{options[:api_path]}/cities/#{record.slug}" if options[:api_path].present?
  end

  def as_json(options = {})
    json = super(options)
    json['self_url'] = self_url(options)
    json
  end
end
