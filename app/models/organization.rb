class Organization < ApplicationRecord
  has_and_belongs_to_many :products, join_table: :organizations_products
  has_and_belongs_to_many :locations, join_table: :organizations_locations
  has_and_belongs_to_many :contacts, join_table: :organizations_contacts
  has_and_belongs_to_many :sectors, join_table: :organizations_sectors

  mount_uploader :logo, LogoUploader

  validates :name,  presence: true, length: { maximum: 300 }

  scope :name_contains, -> (name) { where("LOWER(organizations.name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(organizations.slug) like LOWER(?)", "#{slug}\\_%")}

  def image_file
    if !logo.nil? && !logo.blank?
      return logo
    elsif File.exist?(File.join('app','assets','images','organizations',"#{slug}.png"))
        return "organizations/#{slug}.png"
    else
      return "organizations/org_placeholder.png"
    end
  end

end
