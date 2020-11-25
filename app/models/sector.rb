class Sector < ApplicationRecord
  has_and_belongs_to_many :organizations

  has_many :product_sectors
  has_many :products, through: :product_sectors

  has_many :use_cases, dependent: :restrict_with_error
  belongs_to :origin

  validates :name,  presence: true, length: { maximum: 300 }

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%")}

  def self.build_list
    origin_name = Setting.find_by(slug: 'default_sector_list').value
    origin_id = Origin.find_by(name: origin_name).id
    sector_list = Sector.where(origin_id: origin_id, parent_sector_id: nil).order(:name).as_json
    child_sectors = Sector.where("origin_id = ? and parent_sector_id is not null", origin_id)
    child_sectors.each do |child_sector|
      parent_sector = sector_list.select{|sector| sector["id"] == child_sector.parent_sector_id}[0]
      child_sector.name = parent_sector["name"] + " - " + child_sector.name
      insert_index = sector_list.index { |sector| sector["id"] == child_sector.parent_sector_id } || -1

      sector_list.insert(insert_index+1, child_sector.as_json)
    end

    sector_list.map { |sector| {"name" => sector['name'] , "id" => sector['id']} }
  end

  def to_param  # overridden
    slug
  end

end
