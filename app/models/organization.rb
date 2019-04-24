class Organization < ApplicationRecord
  has_and_belongs_to_many :products, join_table: :organizations_products
  has_and_belongs_to_many :locations, join_table: :organizations_locations
  has_and_belongs_to_many :contacts, join_table: :organizations_contacts
  has_and_belongs_to_many :sectors, join_table: :organizations_sectors

  validates :name,  presence: true, length: { maximum: 300 }

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}%")}

  def no_duplicates
    size = Organization.where(slug: slug).size
    if size > 0
      errors.add(:duplicate, 'has duplicate.')
    end
  end

end
