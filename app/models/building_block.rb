class BuildingBlock < ApplicationRecord
  include EntityStatusType
  include Auditable

  has_many :product_building_blocks,
           after_add: :association_add, before_remove: :association_remove
  has_many :products, through: :product_building_blocks,
           after_add: :association_add, before_remove: :association_remove

  has_and_belongs_to_many :workflows, join_table: :workflows_building_blocks,
                          after_add: :association_add, before_remove: :association_remove

  has_many :building_block_descriptions, dependent: :destroy

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%") }
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%") }

  acts_as_commontable

  attr_accessor :bb_desc

  def image_file
    if File.exist?(File.join('public', 'assets', 'building_blocks', "#{slug}.png"))
      "/assets/building_blocks/#{slug}.png"
    else
      '/assets/building_blocks/bb_placeholder.png'
    end
  end

  # overridden
  def to_param
    slug
  end
end
