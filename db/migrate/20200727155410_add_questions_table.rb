# frozen_string_literal: true

class AddQuestionsTable < ActiveRecord::Migration[5.2]
  def change
    create_table(:playbook_questions) do |t|
      t.string(:question_text, null: false)
    end

    create_table(:playbook_answers) do |t|
      t.references(:playbook_questions, foreign_key: true)
      t.string(:answer_text, null: false)
      t.string(:action, null: false)
      t.integer(:object_id)
    end

    add_reference(:activities, :playbook_questions, foreign_key: true)
    add_reference(:tasks, :playbook_questions, foreign_key: true)

    add_column(:activities, :order, :integer)
    add_column(:tasks, :order, :integer)

    add_column(:activities, :media_url, :string)
    add_column(:tasks, :media_url, :string)
  end
end
