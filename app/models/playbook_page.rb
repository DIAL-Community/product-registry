class PlaybookPage < ApplicationRecord
  belongs_to :playbook

  attr_accessor :question_text, :child_pages, :content_html, :content_css
  attr_accessor :snippet

  has_many :page_contents, dependent: :destroy

  def to_param
    slug
  end
end
