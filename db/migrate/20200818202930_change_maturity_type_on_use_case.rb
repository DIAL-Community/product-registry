class ChangeMaturityTypeOnUseCase < ActiveRecord::Migration[5.2]
  def up
    change_column_default(:use_cases, :maturity, nil)
    change_column(:use_cases,
                  :maturity,
                  "entity_status_type USING (CASE UPPER(maturity)
                      WHEN 'SELF-REPORTED' THEN 'SELF-REPORTED'::entity_status_type
                      WHEN 'BETA' THEN 'BETA'::entity_status_type
                      WHEN 'MATURE' THEN 'MATURE'::entity_status_type
                      WHEN 'VALIDATED' THEN 'VALIDATED'::entity_status_type END
                   )",
                  null: false)
    change_column_default(:use_cases, :maturity, 'BETA')
  end

  def down
    change_column_default(:use_cases, :maturity, nil)
    change_column(:use_cases,
                  :maturity,
                  "varchar(16) USING (CASE maturity
                      WHEN 'SELF-REPORTED' THEN 'SELF-REPORTED'
                      WHEN 'BETA' THEN 'BETA'
                      WHEN 'MATURE' THEN 'MATURE'
                      WHEN 'VALIDATED' THEN 'VALIDATED' END
                   )",
                  null: false)
    change_column_default(:use_cases, :maturity, 'BETA')
  end
end
