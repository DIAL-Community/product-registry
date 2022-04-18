# frozen_string_literal: true

class DropForeignKeyUseCasesWorkflows < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key('workflows_use_cases', name: 'workflows_usecases_workflow_fk')
    remove_foreign_key('workflows_use_cases', name: 'workflows_usecases_usecase_fk')
  end
end
