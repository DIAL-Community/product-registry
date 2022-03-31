# frozen_string_literal: true

class HandbookAnswer < ApplicationRecord
  belongs_to :handbook_question
end
