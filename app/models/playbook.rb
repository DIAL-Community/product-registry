class Playbook < ApplicationRecord
  include Auditable
  attr_accessor :playbook_overview, :playbook_audience, :playbook_outcomes
  
  has_many :playbook_descriptions, dependent: :destroy
  has_many :playbook_pages, dependent: :destroy

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  def to_param
    slug
  end

  def image_file
    if File.exist?(File.join('public','assets','playbooks',"#{slug}.png"))
      return "/assets/playbooks/#{slug}.png"
    else
      return "/assets/playbooks/playbook_placeholder.png"
    end
  end
end
