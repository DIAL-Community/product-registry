class Sector < ApplicationRecord
  attr_accessor :parent_sector_name
  
  has_and_belongs_to_many :organizations

  has_many :product_sectors
  has_many :products, through: :product_sectors

  has_many :use_cases, dependent: :restrict_with_error
  belongs_to :origin

  validates :name,  presence: true, length: { maximum: 300 }

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%")}

  def self.build_filter(origin_name)
    sector_list = build_list(origin_name)
    sector_list.map { |sector| {"name" => sector['name'] , "id" => sector['id']} }
  end

  def self.build_list(origin_name)
    origin = Origin.find_by(name: origin_name)
    if origin.nil?
      origin = Origin.find_by(name:Setting.find_by(slug: 'default_sector_list').value)
    end
    sector_list = Sector.where(origin_id: origin.id, parent_sector_id: nil).order(:name).as_json
    child_sectors = Sector.where("origin_id = ? and parent_sector_id is not null", origin.id)
    child_sectors.each do |child_sector|
      insert_index = sector_list.index { |sector| sector["id"] == child_sector.parent_sector_id } || -1

      sector_list.insert(insert_index+1, child_sector.as_json)
    end

    sector_list    
  end

  def to_param  # overridden
    slug
  end

end
