module Types
  class PlaybookAnswerType < Types::BaseObject
    field :id, ID, null: false
    field :answer_text, String, null: false
    field :locale, String, null: false
    field :action, String, null: false
  end
end
