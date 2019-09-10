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

  def association_add(new_obj)
    initialize_association_changes
    curr_change = {id: new_obj.slug, action: "ADD"}
    log_association(curr_change, new_obj.class.name)
  end

  def association_remove(old_obj)
    initialize_association_changes
    curr_change = {id: old_obj.slug, action: "REMOVE"}
    log_association(curr_change, old_obj.class.name)
  end

  def log_association(curr_change, obj_name)
    case obj_name
    when "Sector"
      @association_changes[:sectors] << curr_change
    when "Product"
      @association_changes[:products] << curr_change
    when "Location"
      @association_changes[:locations] << curr_change
    when "Contact"
      @association_changes[:contacts] << curr_change
    when "Project"
      @association_changes[:projects] << curr_change
    end
  end

  def initialize_association_changes
    @association_changes = {sectors: [], products: [], locations: [], contacts: [], projects: []} if @association_changes.nil?
  end

  def association_changes
    @association_changes
  end

  def image_file
    if File.exist?(File.join('app','assets','images','organizations',"#{slug}.png"))
      return "organizations/#{slug}.png"
    else
      return "organizations/org_placeholder.png"
    end
  end

  def to_param  # overridden
    slug
  end

end
