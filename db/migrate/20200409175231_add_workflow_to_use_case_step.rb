class AddWorkflowToUseCaseStep < ActiveRecord::Migration[5.1]
  def change
    create_table 'use_case_steps_workflows', id: false, force: :cascade do |t|
      t.bigint 'use_case_step_id', null: false
      t.bigint 'workflow_id', null: false
      t.index ['workflow_id', 'use_case_step_id'], name: 'workflows_use_case_steps_idx', unique: true
      t.index ['use_case_step_id', 'workflow_id'], name: 'use_case_steps_workflows_idx', unique: true
    end

    add_foreign_key 'use_case_steps_workflows', 'use_case_steps', name: 'use_case_steps_workflows_step_fk'
    add_foreign_key 'use_case_steps_workflows', 'workflows', name: 'use_case_steps_workflows_workflow_fk'
  end
end
