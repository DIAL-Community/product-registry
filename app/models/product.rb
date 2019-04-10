class Product < ApplicationRecord
  has_and_belongs_to_many :organizations
<<<<<<< HEAD
  has_one :product_assessment

=======
  has_and_belongs_to_many :building_blocks, join_table: :products_building_blocks
>>>>>>> 3080cd3cf0366940239c1c4f02810d6649b096b8
  validates :name,  presence: true, length: { maximum: 300 }

  scope :starts_with, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
end
