class Origin < ApplicationRecord
    belongs_to :organization, optional: true
    has_and_belongs_to_many :products, join_table: :products_origins
end
