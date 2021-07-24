class OrganizationsSector < ApplicationRecord
  belongs_to :organization
  belongs_to :sector
end