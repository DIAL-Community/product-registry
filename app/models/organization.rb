class Organization < ApplicationRecord 
  include Auditable

  has_and_belongs_to_many :products, join_table: :organizations_products, after_add: :association_add, before_remove: :association_remove
  has_and_belongs_to_many :locations, join_table: :organizations_locations, after_add: :association_add, before_remove: :association_remove
  has_and_belongs_to_many :contacts, join_table: :organizations_contacts, after_add: :association_add, before_remove: :association_remove
  has_and_belongs_to_many :sectors, join_table: :organizations_sectors, after_add: :association_add, before_remove: :association_remove
  has_and_belongs_to_many :projects, join_table: :projects_organizations, dependent: :delete_all, after_add: :association_add, before_remove: :association_remove
  
  validates :name,  presence: true, length: { maximum: 300 }

  scope :name_contains, -> (name) { where("LOWER(organizations.name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(organizations.slug) like LOWER(?)", "#{slug}\\_%")}

  def image_file
    if File.exist?(File.join('public','assets','organizations',"#{slug}.png"))
      return "/assets/organizations/#{slug}.png"
    else
      return "/assets/organizations/org_placeholder.png"
    end
  end

  def to_param  # overridden
    slug
  end

end
