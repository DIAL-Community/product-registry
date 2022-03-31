# frozen_string_literal: true

class AddLocaleToPlaybookAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column(:playbook_answers, :locale, :string, null: false, default: 'en')
    remove_column(:playbook_answers, :object_id, :bigint)
    remove_column(:playbook_answers, :playbook_questions_id, :bigint)

    add_reference(:playbook_answers, :playbook_question, index: true)
  end
end
