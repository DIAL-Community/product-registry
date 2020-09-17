class Office < ApplicationRecord
  belongs_to :organization
  belongs_to :country
  belongs_to :region
end
