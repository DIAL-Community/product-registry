class Contact < ApplicationRecord
  has_and_belongs_to_many :organizations, join_table: :organizations_contacts
  
  scope :starts_with, -> (name) { where("LOWER(name) like LOWER(?)", "#{name}%")}
end
