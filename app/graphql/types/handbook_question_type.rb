# frozen_string_literal: true

module Types
  class HandbookQuestionType < Types::BaseObject
    field :id, ID, null: false
    field :question_text, String, null: false
    field :locale, String, null: false

    field :handbook_answers, [Types::HandbookAnswerType], null: true
  end
end
