# frozen_string_literal: true

class UseCaseDescription < ApplicationRecord
  include Auditable
  belongs_to :use_case
end
