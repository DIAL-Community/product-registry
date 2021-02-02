module Types
  class PlaybookQuestionType < Types::BaseObject
    field :id, ID, null: false
    field :question_text, String, null: false
    field :locale, String, null: false

    field :playbook_answers, [Types::PlaybookAnswerType], null: true
  end
end
