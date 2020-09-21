class Activity < ApplicationRecord
  include Auditable

  attr_accessor :question_text, :activity_description
  
  belongs_to :playbook
  has_many :activity_descriptions, dependent: :destroy
  has_and_belongs_to_many :tasks, join_table: :activities_tasks, dependent: :destroy

  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%")}

  def to_param  # overridden
    slug
  end
end