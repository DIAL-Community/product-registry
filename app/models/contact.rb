# frozen_string_literal: true

class Contact < ApplicationRecord
  has_many :organizations_contacts
  has_many :organizations, through: :organizations_contacts

  validates :name, presence: true, length: { maximum: 300 }

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  # overridden
  def to_param
    slug
  end
end
