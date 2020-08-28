class ProductSustainableDevelopmentGoal < ApplicationRecord
  include MappingStatusType
  include AssociationSource

  belongs_to :product
  belongs_to :sustainable_development_goal

  after_initialize :default_association_source, if: :auditable_association_object

  def default_association_source
    self.association_source = ProductSustainableDevelopmentGoal.LEFT
  end

  def generate_slug
    if !product.nil? && !sustainable_development_goal.nil?
      self.slug = "#{product.slug}_#{sustainable_development_goal.number}"
    end
  end

  def audit_id_value
    if association_source == ProductSustainableDevelopmentGoal.LEFT
      sustainable_development_goal&.number
    else
      product&.slug
    end
  end

  def audit_field_name
    if association_source == ProductSustainableDevelopmentGoal.LEFT
      SustainableDevelopmentGoal.name.pluralize.downcase
    else
      Product.name.pluralize.downcase
    end
  end
end
