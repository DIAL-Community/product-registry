class CandidateOrganization < ApplicationRecord
  include Auditable

  validates :name, presence: true, length: { maximum: 300 }

  scope :name_contains, ->(name) { where('LOWER(candidate_organizations.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(candidate_organizations.slug) like LOWER(?)', "#{slug}\\_%") }

  def to_param
    slug
  end
end
