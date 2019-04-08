class Sector < ApplicationRecord
  has_and_belongs_to_many :organizations

  validates :name,  presence: true, length: { maximum: 300 }

  scope :starts_with, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
end
