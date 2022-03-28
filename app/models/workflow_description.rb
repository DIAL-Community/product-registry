# frozen_string_literal: true

class WorkflowDescription < ApplicationRecord
  include Auditable
  belongs_to :workflow
end
