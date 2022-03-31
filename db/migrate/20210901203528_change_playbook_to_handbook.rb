# frozen_string_literal: true

class ChangePlaybookToHandbook < ActiveRecord::Migration[5.2]
  def change
    rename_table :playbooks, :handbooks
    rename_table :playbook_pages, :handbook_pages
    rename_table :playbook_descriptions, :handbook_descriptions
    rename_table :playbook_questions, :handbook_questions
    rename_table :playbook_answers, :handbook_answers

    rename_column :handbook_descriptions, :playbook_id, :handbook_id
    rename_column :handbook_pages, :playbook_id, :handbook_id
    rename_column :handbook_pages, :playbook_questions_id, :handbook_questions_id
    rename_column :handbook_questions, :playbook_page_id, :handbook_page_id
    rename_column :handbook_answers, :playbook_question_id, :handbook_question_id

    rename_column :page_contents, :playbook_page_id, :handbook_page_id
  end
end
