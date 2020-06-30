class ProjectLocation < ApplicationRecord
  belongs_to :project
  belongs_to :location
end
