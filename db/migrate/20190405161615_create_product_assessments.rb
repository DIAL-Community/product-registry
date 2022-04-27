# frozen_string_literal: true

class CreateProductAssessments < ActiveRecord::Migration[5.1]
  def change
    create_table(:product_assessments) do |t|
      t.references(:product, foreign_key: true)

      t.boolean(:has_osc)
      t.boolean(:has_digisquare)

      t.boolean(:osc_cd10)
      t.boolean(:osc_cd20)
      t.boolean(:osc_cd21)
      t.boolean(:osc_cd30)
      t.boolean(:osc_cd31)
      t.boolean(:osc_cd40)
      t.boolean(:osc_cd50)
      t.boolean(:osc_cd60)
      t.boolean(:osc_cd61)

      t.boolean(:osc_lc10)
      t.boolean(:osc_lc20)
      t.boolean(:osc_lc30)
      t.boolean(:osc_lc40)
      t.boolean(:osc_lc50)
      t.boolean(:osc_lc60)

      t.boolean(:osc_re10)
      t.boolean(:osc_re30)
      t.boolean(:osc_re40)
      t.boolean(:osc_re50)
      t.boolean(:osc_re60)
      t.boolean(:osc_re70)
      t.boolean(:osc_re80)

      t.boolean(:osc_qu10)
      t.boolean(:osc_qu11)
      t.boolean(:osc_qu12)
      t.boolean(:osc_qu20)
      t.boolean(:osc_qu30)
      t.boolean(:osc_qu40)
      t.boolean(:osc_qu50)
      t.boolean(:osc_qu51)
      t.boolean(:osc_qu52)
      t.boolean(:osc_qu60)
      t.boolean(:osc_qu70)
      t.boolean(:osc_qu71)
      t.boolean(:osc_qu80)
      t.boolean(:osc_qu90)
      t.boolean(:osc_qu100)

      t.boolean(:osc_co10)
      t.boolean(:osc_co20)
      t.boolean(:osc_co30)
      t.boolean(:osc_co40)
      t.boolean(:osc_co50)
      t.boolean(:osc_co60)
      t.boolean(:osc_co70)
      t.boolean(:osc_co71)
      t.boolean(:osc_co72)
      t.boolean(:osc_co73)
      t.boolean(:osc_co80)

      t.boolean(:osc_cs10)
      t.boolean(:osc_cs20)
      t.boolean(:osc_cs30)
      t.boolean(:osc_cs40)
      t.boolean(:osc_cs50)

      t.boolean(:osc_in10)
      t.boolean(:osc_in20)
      t.boolean(:osc_in30)

      t.boolean(:osc_im10)
      t.boolean(:osc_im20)

      t.integer(:digisquare_country_utilization)
      t.integer(:digisquare_country_strategy)
      t.integer(:digisquare_digital_health_interventions)
      t.integer(:digisquare_source_code_accessibility)
      t.integer(:digisquare_funding_and_revenue)
      t.integer(:digisquare_developer_contributor_and_implementor_community_engagement)
      t.integer(:digisquare_community_governance)
      t.integer(:digisquare_software_roadmap)
      t.integer(:digisquare_user_documentation)
      t.integer(:digisquare_multilingual_support)
      t.integer(:digisquare_technical_documentation)
      t.integer(:digisquare_software_productization)
      t.integer(:digisquare_interoperability_and_data_accessibility)
      t.integer(:digisquare_security)
      t.integer(:digisquare_scalability)

      t.timestamps
    end
  end
end
