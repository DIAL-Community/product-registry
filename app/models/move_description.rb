class MoveDescription < ApplicationRecord
  include Auditable
  belongs_to :play_move
end