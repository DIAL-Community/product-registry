# frozen_string_literal: true

class ProductRepository < ApplicationRecord
  belongs_to :product

  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }
end
