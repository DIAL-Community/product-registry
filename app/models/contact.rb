class Contact < ApplicationRecord
  has_and_belongs_to_many :organizations, join_table: :organizations_contacts
end
