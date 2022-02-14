class Play < ApplicationRecord
  include Auditable

  has_many :play_descriptions, dependent: :destroy
  has_many :play_moves, dependent: :destroy
  has_and_belongs_to_many :playbooks, join_table: :playbook_plays

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
