class RubricCategory < ApplicationRecord
  attr_accessor :rc_desc

  belongs_to :maturity_rubric
  has_many :category_indicators

  has_many :rubric_category_descriptions, dependent: :destroy

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  # overridden
  def to_param
    slug
  end
end
