# frozen_string_literal: true

class PlaybookPlay < ApplicationRecord
  include Auditable
  belongs_to :playbook
  belongs_to :play
end
