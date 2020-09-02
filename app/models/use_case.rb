class UseCase < ApplicationRecord
  include EntityStatusType
  include Auditable

  belongs_to :sector
  has_many :sdg_targets,
           after_add: :association_add, before_remove: :association_remove

  has_many :use_case_steps, dependent: :destroy
  has_many :use_case_headers, dependent: :destroy
  has_many :use_case_descriptions, dependent: :destroy

  has_and_belongs_to_many :sdg_targets, join_table: :use_cases_sdg_targets,
    after_add: :association_add, before_remove: :association_remove

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%") }
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%") }

  acts_as_commontable

  attr_accessor :uc_desc
  attr_accessor :ucs_header

  def image_file
    if File.exist?(File.join('public', 'assets', 'use_cases', "#{slug}.png"))
      "/assets/use_cases/#{slug}.png"
    else
      '/assets/use_cases/use_case_placeholder.png'
    end
  end

  # overridden
  def to_param
    slug
  end
end
