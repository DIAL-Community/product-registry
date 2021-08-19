class CandidateProduct < ApplicationRecord
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }
  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
end
