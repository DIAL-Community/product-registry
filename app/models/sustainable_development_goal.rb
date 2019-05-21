class SustainableDevelopmentGoal < ApplicationRecord
  has_and_belongs_to_many :products

  def image_file
    if File.exist?(File.join('app','assets','images','sdgs',"#{slug}.png"))
      return "sdgs/#{slug}.png"
    end

    "sdgs/sdg_placeholder.png"
  end
end
