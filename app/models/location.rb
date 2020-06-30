class Location < ApplicationRecord
  has_many :organizations, through: :organizations_locations
  has_many :organizations_locations
  enum location_type: { point: 'point', country: 'country' }

  validates :name, presence: true, length: { maximum: 300 }

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%") }
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%") }

  def to_param # overridden
    slug
  end
end
