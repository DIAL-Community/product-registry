# frozen_string_literal: true

class ProjectsProduct < ApplicationRecord
  belongs_to :product
  belongs_to :project
end
