class PortalView < ApplicationRecord
  enum top_nav: { sdgs: 'sdgs', use_cases: 'use_cases', workflows: 'workflows',
                  building_blocks: 'building_blocks', products: 'products',
                  projects: 'projects', organizations: 'organizations' }, _suffix: true
  enum filter_nav: { sdgs: 'sdgs', use_cases: 'use_cases', workflows: 'workflows',
                     building_blocks: 'building_blocks', products: 'products',
                     projects: 'projects', organizations: 'organizations',
                     locations: 'locations', sectors: 'sectors' }, _suffix: true
  scope :name_contains, ->(name) { where('LOWER(portal_views.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(portal_views.slug) like LOWER(?)', "#{slug}%\\_") }
end
