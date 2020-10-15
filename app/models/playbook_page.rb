class PlaybookPage < ApplicationRecord
  belongs_to :playbook

  attr_accessor :question_text
end
