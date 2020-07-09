class Activity < ApplicationRecord

  belongs_to :playbook
  has_and_belongs_to_many :tasks, join_table: :activities_tasks, dependent: :destroy

  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%")}

  def to_param  # overridden
    slug
  end
end