class PlaybookPage < ApplicationRecord
  belongs_to :playbook

  attr_accessor :question_text, :child_pages

  def to_param
    slug
  end
end
