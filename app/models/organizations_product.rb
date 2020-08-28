class OrganizationsProduct < ApplicationRecord
  include AssociationSource

  belongs_to :organization
  belongs_to :product

  enum org_type: { owner: 'owner', maintainer: 'maintainer', funder: 'funder' }

  after_initialize :set_default_type, if: :new_record?
  after_initialize :default_association_source, if: :auditable_association_object

  def default_association_source
    self.association_source = OrganizationsProduct.LEFT
  end

  def generate_slug
    if !organization.nil? && !product.nil?
      self.slug = "#{organization.slug}_#{product.slug}"
    end
  end

  def set_default_type
    self.org_type ||= :owner
  end

  def audit_id_value
    if association_source == OrganizationsProduct.LEFT
      product&.slug
    else
      organization&.slug
    end
  end

  def audit_field_name
    if association_source == OrganizationsProduct.LEFT
      Product.name.pluralize.downcase
    else
      Organization.name.pluralize.downcase
    end
  end
end
