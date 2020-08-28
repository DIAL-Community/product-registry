class Play < ApplicationRecord
  include Auditable
  attr_accessor :play_outcomes, :play_description, :play_prerequisites, :playbook_id, :activity_id

  has_many :play_descriptions, dependent: :destroy
  has_and_belongs_to_many :activities, join_table: :activities_plays
  has_and_belongs_to_many :tasks, join_table: :plays_tasks

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  def to_param
    slug
  end
end
