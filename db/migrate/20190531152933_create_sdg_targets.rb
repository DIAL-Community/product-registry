# frozen_string_literal: true

class CreateSdgTargets < ActiveRecord::Migration[5.1]
  def change
    create_table :sdg_targets do |t|
      t.string :name
      t.string :target_number
      t.string :slug
      t.integer :sdg_number

      t.timestamps
    end
    create_table 'use_cases_sdg_targets', id: false, force: :cascade do |t|
      t.bigint 'use_case_id', null: false
      t.bigint 'sdg_target_id', null: false
      t.index %w[sdg_target_id use_case_id], name: 'sdgs_usecases', unique: true
      t.index %w[use_case_id sdg_target_id], name: 'usecases_sdgs', unique: true
    end

    add_foreign_key 'use_cases_sdg_targets', 'use_cases', name: 'usecases_sdgs_usecase_fk'
    add_foreign_key 'use_cases_sdg_targets', 'sdg_targets', name: 'usecases_sdgs_sdg_fk'
  end
end
