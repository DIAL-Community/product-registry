class Tag < ApplicationRecord
  attr_accessor :tag_desc

  has_many :tag_descriptions

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  def to_param
    slug
  end
end
