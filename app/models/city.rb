class City < ApplicationRecord
  belongs_to :region
  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%") }
  def to_param
    slug
  end
end
