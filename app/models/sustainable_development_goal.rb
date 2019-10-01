class SustainableDevelopmentGoal < ApplicationRecord
  has_and_belongs_to_many :products
  has_many :sdg_targets, :foreign_key => 'sdg_number', :primary_key => 'number'

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}

  def image_file
    if File.exist?(File.join('app','assets','images','sdgs',"#{slug}.png"))
      return "sdgs/#{slug}.png"
    end

    "sdgs/sdg_placeholder.png"
  end

  def option_label
    "#{number}. #{name}"
  end
end
