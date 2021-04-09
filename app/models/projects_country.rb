class ProjectsCountry < ApplicationRecord
  belongs_to :project
  belongs_to :country
end
