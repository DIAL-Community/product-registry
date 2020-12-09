class Country < ApplicationRecord
  has_and_belongs_to_many :organizations, join_table: :organizations_countries
  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%") }

  def to_param
    slug
  end

  def self_url(options = {})
    return "#{options[:api_path]}/countries/#{slug}" if options[:api_path].present?
    return options[:item_path] if options[:item_path].present?
    return "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/countries" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    return options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    return options[:item_path].sub("/countries/#{slug}", '') if options[:item_path].present?
    return options[:collection_path].sub('/countries', '') if options[:collection_path].present?
  end

  def as_json(options = {})
    json = super(options)
    if options[:include_relationships].present?
      json['organizations'] = organizations.as_json({ only: [:name, :slug, :website], api_path: api_path(options) })
    end
    if options[:collection_path].present? || options[:api_path].present?
      json['self_url'] = self_url(options)
    end
    if options[:item_path].present?
      json['collection_url'] = collection_url(options)
    end
    json
  end

  def self.serialization_options
    {
      except: [:id, :created_at, :updated_at]
    }
  end
end
