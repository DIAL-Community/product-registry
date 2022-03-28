# frozen_string_literal: true

class ProjectsSector < ApplicationRecord
  belongs_to :project
  belongs_to :sector
end
