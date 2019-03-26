class Sector < ApplicationRecord
  has_and_belongs_to_many :organizations
  
  scope :starts_with, -> (name) { where("LOWER(name) like LOWER(?)", "#{name}%")}
end
