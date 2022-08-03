# frozen_string_literal: true

class AddUseCaseStepsBuildingBlocksTable < ActiveRecord::Migration[5.2]
  def change
    create_table(:use_case_steps_building_blocks) do |t|
      t.bigint('use_case_step_id', null: false)
      t.bigint('building_block_id', null: false)
      t.index(%w[use_case_step_id building_block_id], name: 'use_case_steps_building_blocks_idx', unique: true)
      t.index(%w[building_block_id use_case_step_id], name: 'building_blocks_use_case_steps_idx', unique: true)
    end

    add_foreign_key('use_case_steps_building_blocks', 'use_case_steps', name: 'use_case_steps_building_blocks_step_fk')
    add_foreign_key('use_case_steps_building_blocks', 'building_blocks',
                    name: 'use_case_steps_building_blocks_block_fk')
  end
end
