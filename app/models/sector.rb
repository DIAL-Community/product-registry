class Sector < ApplicationRecord
  scope :starts_with, -> (name) { where("LOWER(name) like LOWER(?)", "#{name}%")}
end
