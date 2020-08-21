class ChangeColumnNameLinkType < ActiveRecord::Migration[5.2]
  def up
    change_column(:products_sustainable_development_goals,
                  :link_type,
                  "mapping_status_type USING (CASE UPPER(link_type)
                      WHEN 'SELF-REPORTED' THEN 'SELF-REPORTED'::mapping_status_type
                      WHEN 'BETA' THEN 'BETA'::mapping_status_type
                      WHEN 'MATURE' THEN 'MATURE'::mapping_status_type
                      WHEN 'VALIDATED' THEN 'VALIDATED'::mapping_status_type END
                   )",
                  null: false)
    rename_column(:products_sustainable_development_goals, :link_type, :mapping_status)
  end

  def down
    rename_column(:products_sustainable_development_goals, :mapping_status, :link_type)
    change_column(:products_sustainable_development_goals,
                  :link_type,
                  "varchar(16) USING (CASE link_type
                      WHEN 'SELF-REPORTED' THEN 'SELF-REPORTED'
                      WHEN 'BETA' THEN 'BETA'
                      WHEN 'MATURE' THEN 'MATURE'
                      WHEN 'VALIDATED' THEN 'VALIDATED' END
                   )",
                  null: false)
  end
end
