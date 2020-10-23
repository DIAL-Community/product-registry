class PlaybookPage < ApplicationRecord
  belongs_to :playbook

  attr_accessor :question_text

  def to_param
    slug
  end
end
