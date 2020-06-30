class Country < ApplicationRecord
  has_and_belongs_to_many :organizations, join_table: :organizations_countries
  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%") }
  def to_param
    slug
  end
end
