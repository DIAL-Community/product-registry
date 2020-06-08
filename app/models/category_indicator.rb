class CategoryIndicator < ApplicationRecord
  enum category_indicator_type: { boolean: 'boolean', numeric: 'numeric', scale: 'scale' }

  attr_accessor :ci_desc

  belongs_to :rubric_category
  has_many :category_indicator_descriptions, dependent: :destroy

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  # overridden
  def to_param
    slug
  end
end
