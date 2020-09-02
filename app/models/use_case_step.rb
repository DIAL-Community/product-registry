class UseCaseStep < ApplicationRecord
  include Auditable

  belongs_to :use_case

  has_many :use_case_step_descriptions, dependent: :destroy
  attr_accessor :ucs_desc
  has_and_belongs_to_many :products, join_table: :use_case_steps_products,
                          after_add: :association_add, before_remove: :association_remove
  has_and_belongs_to_many :workflows, join_table: :use_case_steps_workflows,
                          after_add: :association_add, before_remove: :association_remove

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  # overridden
  def to_param
    slug
  end
end
