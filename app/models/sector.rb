# frozen_string_literal: true

class Sector < ApplicationRecord
  attr_accessor :parent_sector_name

  has_and_belongs_to_many :organizations

  has_many :product_sectors
  has_many :products, through: :product_sectors, dependent: :destroy

  has_many :dataset_sectors
  has_many :datasets, through: :dataset_sectors, dependent: :destroy

  has_and_belongs_to_many :projects, join_table: :projects_sectors

  belongs_to :parent_sector, class_name: :Sector, optional: true
  has_many :sectors, foreign_key: :parent_sector_id, dependent: :destroy

  has_many :use_cases, dependent: :destroy
  belongs_to :origin

  validates :name, presence: true, length: { maximum: 300 }

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  def self.build_filter(origin_name)
    sector_list = build_list(origin_name)
    sector_list.map { |sector| { 'name' => sector['name'], 'id' => sector['id'] } }
  end

  def self.build_list(origin_name)
    origin = Origin.find_by(name: origin_name)
    origin = Origin.find_by(name: Setting.find_by(slug: 'default_sector_list').value) if origin.nil?
    sector_list = Sector.where(origin_id: origin.id, parent_sector_id: nil, locale: I18n.locale,
                               is_displayable: true).order(:name).as_json
    child_sectors = Sector.where(
      'origin_id = ? and locale = ? and is_displayable=true and parent_sector_id is not null', origin.id, I18n.locale
    )
    child_sectors.each do |child_sector|
      insert_index = sector_list.index { |sector| sector['id'] == child_sector.parent_sector_id } || -1

      sector_list.insert(insert_index + 1, child_sector.as_json)
    end

    sector_list
  end

  def sub_sectors
    Sector.where(parent_sector_id: id)
  end

  # overridden
  def to_param
    slug
  end

  def self_url(options = {})
    return "#{options[:api_path]}/sectors/#{slug}" if options[:api_path].present?
    return options[:item_path] if options[:item_path].present?
    return "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/sectors" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    return options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    return options[:item_path].sub("/sectors/#{slug}", '') if options[:item_path].present?
    return options[:collection_path].sub('/sectors', '') if options[:collection_path].present?
  end

  def as_json(options = {})
    json = super(options)
    if options[:include_relationships].present?
      json['organizations'] = organizations.as_json({ only: %i[name slug website], api_path: api_path(options) })
      json['use_cases'] = use_cases.as_json({ only: %i[name slug], api_path: api_path(options) })
    end
    json['self_url'] = self_url(options) if options[:collection_path].present? || options[:api_path].present?
    json['collection_url'] = collection_url(options) if options[:item_path].present?
    json
  end

  def self.serialization_options
    {
      except: %i[id created_at updated_at]
    }
  end
end
