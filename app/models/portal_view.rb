# frozen_string_literal: true

class PortalView < ApplicationRecord
  enum top_nav: { sdgs: 'sdgs', use_cases: 'use_cases', workflows: 'workflows',
                  building_blocks: 'building_blocks', products: 'products',
                  projects: 'projects', organizations: 'organizations',
                  plays: 'plays', playbooks: 'playbooks' }, _suffix: true
  enum filter_nav: { sdgs: 'sdgs', use_cases: 'use_cases', workflows: 'workflows',
                     building_blocks: 'building_blocks', products: 'products',
                     projects: 'projects', organizations: 'organizations',
                     sectors: 'sectors', playbooks: 'playbooks',
                     plays: 'plays' }, _suffix: true
  scope :name_contains, ->(name) { where('LOWER(portal_views.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(portal_views.slug) like LOWER(?)', "#{slug}%\\_") }
end
