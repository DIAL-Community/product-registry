# frozen_string_literal: true

class Tag < ApplicationRecord
  attr_accessor :tag_desc

  has_many :tag_descriptions, dependent: :destroy

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  def to_param
    slug
  end

  def tag_description_localized
    description = tag_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                  .find_by(locale: I18n.locale)
    if description.nil?
      description = tag_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                    .find_by(locale: 'en')
    end
    description
  end

  def self.serialization_options
    {
      except: %i[created_at updated_at]
    }
  end
end
