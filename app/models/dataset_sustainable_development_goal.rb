# frozen_string_literal: true

class DatasetSustainableDevelopmentGoal < ApplicationRecord
  include MappingStatusType
  include AssociationSource

  belongs_to :dataset
  belongs_to :sustainable_development_goal

  after_initialize :default_association_source, if: :auditable_association_object

  def default_association_source
    self.association_source = DatasetSustainableDevelopmentGoal.LEFT
  end

  def generate_slug
    if !dataset.nil? && !sustainable_development_goal.nil?
      self.slug = "#{dataset.slug}_#{sustainable_development_goal.number}"
    end
  end

  def audit_id_value
    if association_source == DatasetSustainableDevelopmentGoal.LEFT
      sustainable_development_goal&.number
    else
      dataset&.slug
    end
  end

  def audit_field_name
    if association_source == DatasetSustainableDevelopmentGoal.LEFT
      SustainableDevelopmentGoal.name.pluralize.downcase
    else
      Dataset.name.pluralize.downcase
    end
  end
end
