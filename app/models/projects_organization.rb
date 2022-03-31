# frozen_string_literal: true

class ProjectsOrganization < ApplicationRecord
  belongs_to :project
  belongs_to :organization
end
