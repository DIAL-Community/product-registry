class Contact < ApplicationRecord
  has_and_belongs_to_many :organizations, join_table: :organizations_contacts

  validates :name,  presence: true, length: { maximum: 300 }

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%")}

end
