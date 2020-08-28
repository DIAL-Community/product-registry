class Task < ApplicationRecord
  include Auditable
  attr_accessor :task_desc, :parent_play, :parent_playbook, :parent_activity

  has_many :task_descriptions, dependent: :destroy
  has_and_belongs_to_many :plays, join_table: :plays_tasks
  has_and_belongs_to_many :activities, join_table: :activities_tasks, dependent: :destroy
  has_and_belongs_to_many :organizations, join_table: :tasks_organizations, dependent: :destroy

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  def to_param
    slug
  end
end
