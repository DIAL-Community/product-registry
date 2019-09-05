class SdgTarget < ApplicationRecord
  belongs_to :sustainable_development_goal, :foreign_key => 'sdg_number', :primary_key => 'number'

  has_and_belongs_to_many :use_cases, join_table: :use_cases_sdg_targets

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%")}

  def image_file
    png_filename = "GOAL_#{sdg_number}_TARGET_#{target_number.upcase}.png"
    if File.exist?(File.join('app', 'assets', 'images', 'sdg_targets', png_filename))
      return "sdg_targets/#{png_filename}"
    else
      return 'sdg_targets/sdg_target_placeholder.png'
    end
  end
end
