class Workflow < ApplicationRecord
  include Auditable
  has_and_belongs_to_many :use_case_steps, join_table: :use_case_steps_workflows, dependent: :destroy
  has_and_belongs_to_many :building_blocks, join_table: :workflows_building_blocks

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%")}

  attr_accessor :wf_desc

  def image_file
    if File.exist?(File.join('public', 'assets', 'workflows', "#{slug}.svg"))
      return "/assets/workflows/#{slug}.svg"
    else
      return '/assets/workflows/workflow_placeholder.png'
    end
  end

  def to_param  # overridden
    slug
  end
end
