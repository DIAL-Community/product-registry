class ProductProductRelationship < ApplicationRecord
  belongs_to :to_product, foreign_key: 'to_product_id', class_name: 'Product'
  belongs_to :from_product, foreign_key: 'from_product_id', class_name: 'Product'
  enum relationship_type: { contains: 'composed', interoperates_with: 'interoperates'}
end