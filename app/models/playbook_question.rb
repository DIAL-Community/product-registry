class PlaybookQuestion < ApplicationRecord
  belongs_to :playbook_page
  has_many :playbook_answers, autosave: true
end
