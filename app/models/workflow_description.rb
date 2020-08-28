class WorkflowDescription < ApplicationRecord
  include Auditable
  belongs_to :workflow
end