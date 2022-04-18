# frozen_string_literal: true

class ChangeDigisquareMaturityToEnum < ActiveRecord::Migration[5.1]
  def up
    execute(<<-DDL)
    CREATE TYPE digisquare_maturity_level AS ENUM ('low', 'medium', 'high');
    DDL

    change_column(:product_assessments, :digisquare_country_utilization,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_country_utilization'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')

    change_column(:product_assessments, :digisquare_country_strategy,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_country_strategy'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')

    change_column(:product_assessments, :digisquare_digital_health_interventions,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_digital_health_interventions'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')

    change_column(:product_assessments, :digisquare_source_code_accessibility,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_source_code_accessibility'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')

    change_column(:product_assessments, :digisquare_funding_and_revenue,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_funding_and_revenue'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')

    change_column(:product_assessments, :digisquare_developer_contributor_and_implementor_community_engagement,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_developer_contributor_and_implementor_community_engagement'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')

    change_column(:product_assessments, :digisquare_community_governance,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_community_governance'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')

    change_column(:product_assessments, :digisquare_software_roadmap,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_software_roadmap'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')

    change_column(:product_assessments, :digisquare_user_documentation,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_user_documentation'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')

    change_column(:product_assessments, :digisquare_multilingual_support,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_multilingual_support'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')

    change_column(:product_assessments, :digisquare_technical_documentation,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_technical_documentation'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')

    change_column(:product_assessments, :digisquare_software_productization,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_software_productization'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')

    change_column(:product_assessments, :digisquare_interoperability_and_data_accessibility,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_interoperability_and_data_accessibility'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')

    change_column(:product_assessments, :digisquare_security,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_security'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')

    change_column(:product_assessments, :digisquare_scalability,\
                  ' digisquare_maturity_level USING'\
                  ' (CASE digisquare_scalability'\
                  "   WHEN 1 THEN 'low'::digisquare_maturity_level"\
                  "   WHEN 2 THEN 'medium'::digisquare_maturity_level"\
                  "   WHEN 3 THEN 'high'::digisquare_maturity_level"\
                  ' END)')
  end

  def down
    change_column(:product_assessments, :digisquare_country_utilization,\
                  ' integer USING'\
                  ' (CASE digisquare_country_utilization'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    change_column(:product_assessments, :digisquare_country_strategy,\
                  ' integer USING'\
                  ' (CASE digisquare_country_strategy'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    change_column(:product_assessments, :digisquare_digital_health_interventions,\
                  ' integer USING'\
                  ' (CASE digisquare_digital_health_interventions'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    change_column(:product_assessments, :digisquare_source_code_accessibility,\
                  ' integer USING'\
                  ' (CASE digisquare_source_code_accessibility'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    change_column(:product_assessments, :digisquare_funding_and_revenue,\
                  ' integer USING'\
                  ' (CASE digisquare_funding_and_revenue'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    change_column(:product_assessments, :digisquare_developer_contributor_and_implementor_community_engagement,\
                  ' integer USING'\
                  ' (CASE digisquare_developer_contributor_and_implementor_community_engagement'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    change_column(:product_assessments, :digisquare_community_governance,\
                  ' integer USING'\
                  ' (CASE digisquare_community_governance'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    change_column(:product_assessments, :digisquare_software_roadmap,\
                  ' integer USING'\
                  ' (CASE digisquare_software_roadmap'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    change_column(:product_assessments, :digisquare_user_documentation,\
                  ' integer USING'\
                  ' (CASE digisquare_user_documentation'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    change_column(:product_assessments, :digisquare_multilingual_support,\
                  ' integer USING'\
                  ' (CASE digisquare_multilingual_support'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    change_column(:product_assessments, :digisquare_technical_documentation,\
                  ' integer USING'\
                  ' (CASE digisquare_technical_documentation'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    change_column(:product_assessments, :digisquare_software_productization,\
                  ' integer USING'\
                  ' (CASE digisquare_software_productization'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    change_column(:product_assessments, :digisquare_interoperability_and_data_accessibility,\
                  ' integer USING'\
                  ' (CASE digisquare_interoperability_and_data_accessibility'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    change_column(:product_assessments, :digisquare_security,\
                  ' integer USING'\
                  ' (CASE digisquare_security'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    change_column(:product_assessments, :digisquare_scalability,\
                  ' integer USING'\
                  ' (CASE digisquare_scalability'\
                  "   WHEN 'low' THEN 1"\
                  "   WHEN 'medium' THEN 2"\
                  "   WHEN 'high' THEN 3"\
                  ' END)')

    execute('DROP type digisquare_maturity_level;')
  end
end
