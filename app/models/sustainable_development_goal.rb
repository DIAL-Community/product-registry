# frozen_string_literal: true

class SustainableDevelopmentGoal < ApplicationRecord
  has_many :product_sustainable_development_goals
  has_many :products, through: :product_sustainable_development_goals

  has_many :sdg_targets, foreign_key: 'sdg_number', primary_key: 'number'

  scope :name_contains, ->(name) { where('LOWER(sustainable_development_goals.name) like LOWER(?)', "%#{name}%") }

  def image_file
    return "/assets/sdgs/#{slug}.png" if File.exist?(File.join('public', 'assets', 'sdgs', "#{slug}.png"))

    '/assets/sdgs/sdg_placeholder.png'
  end

  def option_label
    "#{number}. #{name}"
  end

  def self_url(options = {})
    return "#{options[:api_path]}/sdgs/#{slug}" if options[:api_path].present?
    return options[:item_path] if options[:item_path].present?
    return "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/sdgs" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    return options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    return options[:item_path].sub("/sdgs/#{slug}", '') if options[:item_path].present?
    return options[:collection_path].sub('/sdgs', '') if options[:collection_path].present?
  end

  def as_json(options = {})
    json = super(options)
    ## Should we do granular and control it using params like this?
    # if options[:include_products].present?
    #   json['products'] = products.as_json({ only: [:name, :slug, :website], api_path: api_path(options) })
    # end
    # if options[:include_use_cases].present?
    #   use_cases = []
    #   use_cases += sdg_targets.use_cases
    #   json['use_cases'] = use_cases.uniq.as_json({ only: [:name, :slug], api_path: api_path(options) })
    # end
    ##
    if options[:include_relationships].present?
      # json['products'] = products.as_json({ only: [:name, :slug, :website], api_path: api_path(options) })

      use_cases = []
      use_cases += sdg_targets.map(&:use_cases).flatten
      json['use_cases'] = use_cases.uniq.as_json({ only: %i[name slug], api_path: api_path(options) })
    end
    json['self_url'] = self_url(options) if options[:collection_path].present? || options[:api_path].present?
    json['collection_url'] = collection_url(options) if options[:item_path].present?
    json
  end

  def self.serialization_options
    {
      except: %i[id created_at updated_at],
      include: {
        sdg_targets: { only: %i[name target_number] }
      }
    }
  end
end
