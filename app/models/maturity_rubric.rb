# frozen_string_literal: true

class MaturityRubric < ApplicationRecord
  attr_accessor :mr_desc

  has_many :maturity_rubric_descriptions, dependent: :destroy
  has_many :rubric_categories

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  def self.default_maturity_rubric
    setting = Setting.find_by(slug: Rails.configuration.settings['default_maturity_rubric_slug'])
    return nil if setting.nil?

    setting.value
  end

  # overridden
  def to_param
    slug
  end
end
