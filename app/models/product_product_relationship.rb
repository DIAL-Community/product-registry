# frozen_string_literal: true

class ProductProductRelationship < ApplicationRecord
  include AssociationSource

  belongs_to :to_product, foreign_key: 'to_product_id', class_name: 'Product'
  belongs_to :from_product, foreign_key: 'from_product_id', class_name: 'Product'
  enum relationship_type: { contains: 'composed', interoperates_with: 'interoperates' }

  after_initialize :default_association_source, if: :auditable_association_object

  def default_association_source
    self.association_source = ProductProductRelationship.LEFT
  end

  def generate_slug
    self.slug = "#{from_product.slug}_#{to_product.slug}_#{relationship_type}" if !to_product.nil? && !from_product.nil?
  end

  def audit_id_value
    to_product&.slug
  end

  def audit_field_name
    relationship_type
  end
end
