# frozen_string_literal: true

class CandidateOrganization < ApplicationRecord
  include Auditable
  has_and_belongs_to_many(:contacts, join_table: :candidate_organizations_contacts,
                                     after_add: :association_add, before_remove: :association_remove)

  validates :name, presence: true, length: { maximum: 300 }

  scope :name_contains, ->(name) { where('LOWER(candidate_organizations.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(candidate_organizations.slug) like LOWER(?)', "#{slug}\\_%") }

  def to_param
    slug
  end
end
