class ProductAssessment < ApplicationRecord
  belongs_to :product
  enum digisquare_country_utilization: { low: 'low', medium: 'medium', high: 'high' }
  enum digisquare_country_strategy: { low: 'low', medium: 'medium', high: 'high' }
  enum digisquare_digital_health_interventions: { low: 'low', medium: 'medium', high: 'high' }
  enum digisquare_source_code_accessibility: { low: 'low', medium: 'medium', high: 'high' }
  enum digisquare_funding_and_revenue: { low: 'low', medium: 'medium', high: 'high' }
  enum digisquare_developer_contributor_and_implementor_community_engagement: { low: 'low', medium: 'medium', high: 'high' }
  enum digisquare_community_governance: { low: 'low', medium: 'medium', high: 'high' }
  enum digisquare_software_roadmap: { low: 'low', medium: 'medium', high: 'high' }
  enum digisquare_user_documentation: { low: 'low', medium: 'medium', high: 'high' }
  enum digisquare_multilingual_support: { low: 'low', medium: 'medium', high: 'high' }
  enum digisquare_technical_documentation: { low: 'low', medium: 'medium', high: 'high' }
  enum digisquare_software_productization: { low: 'low', medium: 'medium', high: 'high' }
  enum digisquare_interoperability_and_data_accessibility: { low: 'low', medium: 'medium', high: 'high' }
  enum digisquare_security: { low: 'low', medium: 'medium', high: 'high' }
  enum digisquare_scalability: { low: 'low', medium: 'medium', high: 'high' }
end
