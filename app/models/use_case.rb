class UseCase < ApplicationRecord
  belongs_to :sector
  has_many :sdg_targets
  has_many :use_case_steps, dependent: :destroy

  has_and_belongs_to_many :sdg_targets, join_table: :use_cases_sdg_targets

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%")}

  attr_accessor :uc_desc

  def image_file
    if File.exist?(File.join('public', 'assets', 'use_cases', "#{slug}.png"))
      return "/assets/use_cases/#{slug}.png"
    else
      return '/assets/use_cases/use_case_placeholder.png'
    end
  end
end
