# frozen_string_literal: true

class DatasetSector < ApplicationRecord
  include MappingStatusType
  include AssociationSource

  belongs_to :dataset
  belongs_to :sector

  after_initialize :default_association_source, if: :auditable_association_object

  def default_association_source
    self.association_source = DatasetSector.LEFT
  end

  def generate_slug
    self.slug = "#{dataset.slug}_#{sector.slug}" if !dataset.nil? && !sector.nil?
  end

  def audit_id_value
    if association_source == DatasetSector.LEFT
      sector&.slug
    else
      dataset&.slug
    end
  end

  def audit_field_name
    if association_source == DatasetSector.LEFT
      Sector.name.pluralize.downcase
    else
      Dataset.name.pluralize.downcase
    end
  end
end
