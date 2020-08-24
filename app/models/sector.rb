class Sector < ApplicationRecord
  has_and_belongs_to_many :organizations

  has_many :product_sectors
  has_many :products, through: :product_sectors

  has_many :use_cases, dependent: :restrict_with_error

  validates :name,  presence: true, length: { maximum: 300 }

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%")}

  def to_param  # overridden
    slug
  end

end
