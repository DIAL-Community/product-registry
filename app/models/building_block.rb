class BuildingBlock < ApplicationRecord
  include EntityStatusType

  has_many :product_building_blocks
  has_many :products, through: :product_building_blocks

  has_and_belongs_to_many :workflows, join_table: :workflows_building_blocks

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%") }
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%") }

  acts_as_commontable

  attr_accessor :bb_desc

  def image_file
    if File.exist?(File.join('public', 'assets', 'building_blocks', "#{slug}.png"))
      return "/assets/building_blocks/#{slug}.png"
    else
      return '/assets/building_blocks/bb_placeholder.png'
    end
  end

  def to_param  # overridden
    slug
  end

end
