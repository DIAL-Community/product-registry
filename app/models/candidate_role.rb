class CandidateRole < ApplicationRecord
  scope :email_contains, ->(email) { where('LOWER(email) like LOWER(?)', "%#{email}%") }
end
