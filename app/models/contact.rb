class Contact < ApplicationRecord
  has_and_belongs_to_many :organizations, join_table: :organizations_contacts

  validates :name,  presence: true, length: { maximum: 300 }

  scope :starts_with, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
end