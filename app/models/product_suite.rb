class ProductSuite < ApplicationRecord
  has_and_belongs_to_many :product_versions, join_table: :product_suites_product_versions

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }
end
