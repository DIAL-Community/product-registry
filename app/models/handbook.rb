# frozen_string_literal: true

class Handbook < ApplicationRecord
  include Auditable
  attr_accessor :handbook_overview, :handbook_audience, :handbook_outcomes, :handbook_cover

  has_many :handbook_descriptions, dependent: :destroy
  has_many :handbook_pages, -> { order(page_order: :asc).where(parent_page_id: nil) }, dependent: :destroy

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  def to_param
    slug
  end

  def image_file
    if File.exist?(File.join('public', 'assets', 'playbooks', "#{slug}.png"))
      "/assets/playbooks/#{slug}.png"
    else
      '/assets/playbooks/handbook_placeholder.png'
    end
  end
end
