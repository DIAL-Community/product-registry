class UseCaseStep < ApplicationRecord
  belongs_to :use_case

  has_many :use_case_step_descriptions, dependent: :destroy
  attr_accessor :ucs_desc
  has_and_belongs_to_many :products, join_table: :use_case_steps_products
  has_and_belongs_to_many :workflows, join_table: :use_case_steps_workflows

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  # overridden
  def to_param
    slug
  end
end
