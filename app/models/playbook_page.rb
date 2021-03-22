class PlaybookPage < ApplicationRecord
  belongs_to :playbook

  attr_accessor :question_text, :child_pages, :content_html, :content_css
  attr_accessor :snippet

  has_one :playbook_question, autosave: true
  has_many :page_contents, dependent: :destroy

  scope :slug_starts_with, ->(slug) { where("LOWER(playbook_pages.slug) like LOWER(?)", "#{slug}%\\_") }

end
