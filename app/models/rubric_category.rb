# frozen_string_literal: true

class RubricCategory < ApplicationRecord
  attr_accessor :rc_desc

  has_many :category_indicators

  has_many :rubric_category_descriptions, dependent: :destroy

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  # overridden
  def to_param
    slug
  end

  def rubric_category_description_localized
    description = rubric_category_descriptions
                  .find_by(locale: I18n.locale)
    if description.nil?
      description = rubric_category_descriptions
                    .find_by(locale: 'en')
    end
    description
  end
end
