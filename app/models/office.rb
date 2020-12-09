class Office < ApplicationRecord
  include Modules::Slugger

  belongs_to :organization
  belongs_to :country
  belongs_to :region

  def self_url(options = {})
    record = City.eager_load(:region, region: :country)
                 .find_by(name: city)
    return "#{options[:api_path]}/cities/#{record.slug}" if options[:api_path].present?
  end

  def as_json(options = {})
    json = super(options)
    json['self_url'] = self_url(options)
    json
  end
end
