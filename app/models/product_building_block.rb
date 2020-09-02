class ProductBuildingBlock < ApplicationRecord
  include MappingStatusType
  include AssociationSource

  belongs_to :product
  belongs_to :building_block

  after_initialize :default_association_source, if: :auditable_association_object

  def default_association_source
    self.association_source = ProductBuildingBlock.LEFT
  end

  def generate_slug
    if !product.nil? && !building_block.nil?
      self.slug = "#{product.slug}_#{building_block.slug}"
    end
  end

  def audit_id_value
    if association_source == ProductBuildingBlock.LEFT
      building_block&.slug
    else
      product&.slug
    end
  end

  def audit_field_name
    if association_source == ProductBuildingBlock.LEFT
      BuildingBlock.name.pluralize.downcase
    else
      Product.name.pluralize.downcase
    end
  end
end
