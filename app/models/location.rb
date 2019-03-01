class Location < ApplicationRecord
  has_and_belongs_to_many :organizations, join_table: :organizations_locations
  enum location_type: [:point, :country]
end
