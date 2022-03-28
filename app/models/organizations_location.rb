# frozen_string_literal: true

class OrganizationsLocation < ApplicationRecord
  belongs_to :organization
  belongs_to :location
end
