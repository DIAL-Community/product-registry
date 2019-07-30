class Project < ApplicationRecord
  has_and_belongs_to_many :organizations, join_table: :projects_organizations
  has_and_belongs_to_many :products, join_table: :projects_products
  has_and_belongs_to_many :locations, join_table: :projects_locations
  has_and_belongs_to_many :sectors, join_table: :projects_sectors
  has_and_belongs_to_many :sustainable_development_goal, join_table: :projects_sdgs
end
