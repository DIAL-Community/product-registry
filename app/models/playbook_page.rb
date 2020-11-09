class PlaybookPage < ApplicationRecord
  belongs_to :playbook

  attr_accessor :question_text, :child_pages

  has_many :page_contents, dependent: :destroy

  def to_param
    slug
  end
end
