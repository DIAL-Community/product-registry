# frozen_string_literal: true

class AddLocaleToPlaybookQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column(:playbook_questions, :locale, :string, null: false, default: 'en')
    add_reference(:playbook_questions, :playbook_page, index: true)
  end
end
