# frozen_string_literal: true

class OrganizationsContact < ApplicationRecord
  include AssociationSource

  belongs_to :contact
  belongs_to :organization

  after_initialize :default_association_source, if: :auditable_association_object

  def default_association_source
    self.association_source = OrganizationsContact.LEFT
  end

  def generate_slug
    self.slug = "#{organization.slug}_#{contact.slug}" if !organization.nil? && !contact.nil?
  end

  def audit_id_value
    if association_source == OrganizationsContact.LEFT
      contact&.slug
    else
      organization&.slug
    end
  end

  def audit_field_name
    if association_source == OrganizationsContact.LEFT
      Contact.name.pluralize.downcase
    else
      Organization.name.pluralize.downcase
    end
  end
end
