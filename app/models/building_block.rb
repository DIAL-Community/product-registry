class BuildingBlock < ApplicationRecord
  has_and_belongs_to_many :products, join_table: :products_building_blocks

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}%")}

  def no_duplicates
    size = BuildingBlock.where(slug: slug).size
    if size > 0
      errors.add(:duplicate, 'has duplicate.')
    end
  end

end
