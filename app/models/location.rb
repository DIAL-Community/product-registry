class Location < ApplicationRecord
  has_and_belongs_to_many :organizations, join_table: :organizations_locations
  enum location_type: { point: 'point', country: 'country'}

  validates :name,  presence: true, length: { maximum: 300 }
  validate :no_duplicates

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}%")}

  private

  def no_duplicates
    size = Location.where(slug: slug).size
    if size > 0
      errors.add(:duplicate, 'has duplicate.')
    end
  end

end
