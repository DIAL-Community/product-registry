require('csv')

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

  def self.to_csv
    attributes = %w{id name slug description building_blocks use_case_steps}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |p|
        building_blocks = p.building_blocks
                           .map(&:name)
                           .join('; ')
        use_case_steps = p.use_case_steps
                          .map(&:name)
                          .join('; ')
        csv << [p.id, p.name, p.slug, p.description, building_blocks, use_case_steps]
      end
    end
  end

  def self.serialization_options
    {
      except: [:created_at, :updated_at],
      include: {
        building_blocks: { only: [:name, :slug] },
        use_case_steps: { only: [:name, :slug, :description] }
      }
    }
  end
end
