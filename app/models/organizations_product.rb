class OrganizationsProduct < ApplicationRecord
  enum org_type: { owner: 'owner', maintainer: 'maintainer', funder: 'funder' }
  after_initialize :set_default_type, if: :new_record?

  def set_default_type
    self.org_type ||= :owner
  end

  belongs_to :organization
  belongs_to :product
end