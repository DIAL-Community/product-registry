class TaskTracker < ApplicationRecord
  has_many :task_tracker_descriptions, dependent: :destroy

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%")}

  attr_accessor :tt_desc

  def to_param
    slug
  end
end
