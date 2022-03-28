# frozen_string_literal: true

class MoveDescription < ApplicationRecord
  include Auditable
  belongs_to :play_move
end
