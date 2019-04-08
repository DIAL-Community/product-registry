class Organization < ApplicationRecord
  has_and_belongs_to_many :products, join_table: :organizations_products
  has_and_belongs_to_many :locations, join_table: :organizations_locations
  has_and_belongs_to_many :contacts, join_table: :organizations_contacts
  has_and_belongs_to_many :sectors, join_table: :organizations_sectors


  validates :name,  presence: true, length: { maximum: 300 }

  scope :starts_with, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
end