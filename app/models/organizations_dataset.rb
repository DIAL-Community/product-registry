# frozen_string_literal: true

class OrganizationsDataset < ApplicationRecord
  include AssociationSource

  belongs_to :organization
  belongs_to :dataset

  enum org_type: { owner: 'owner', maintainer: 'maintainer', funder: 'funder', implementer: 'implementer' }

  after_initialize :set_default_type, if: :new_record?
  after_initialize :default_association_source, if: :auditable_association_object

  def default_association_source
    self.association_source = OrganizationsDataset.LEFT
  end

  def generate_slug
    self.slug = "#{organization.slug}_#{dataset.slug}" if !organization.nil? && !dataset.nil?
  end

  def set_default_type
    self.organization_type ||= :owner
  end

  def audit_id_value
    if association_source == OrganizationsDataset.LEFT
      dataset&.slug
    else
      organization&.slug
    end
  end

  def audit_field_name
    if association_source == OrganizationsDataset.LEFT
      Dataset.name.pluralize.downcase
    else
      Organization.name.pluralize.downcase
    end
  end
end
