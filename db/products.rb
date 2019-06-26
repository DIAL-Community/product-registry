if Product.where(slug: 'bahmni').empty?
  p = Product.create(name: "Bahmni", slug: 'bahmni', start_assessment: true) if Product.where(slug: 'bahmni').empty?
  p.building_blocks << BuildingBlock.where(slug: 'artificial_intelligence').limit(1)[0]
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: false, osc_cd30: true, osc_cd31: false, osc_cd40: true, osc_cd50: true, osc_cd60: true, osc_cd61: false,
    osc_lc10: true, osc_lc20: true, osc_lc30: true, osc_lc40: false, osc_lc50: false, osc_lc60: true,
    osc_re10: true, osc_re30: true, osc_re40: true, osc_re50: true, osc_re60: true, osc_re70: true, osc_re80: true,
    osc_qu10: true, osc_qu11: false, osc_qu12: false, osc_qu20: true, osc_qu30: false, osc_qu40: true, osc_qu50: true, osc_qu51: true, osc_qu52: false, osc_qu60: true, osc_qu70: true, osc_qu71: true, osc_qu80: true, osc_qu90: true, osc_qu100: true,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: true, osc_co50: false, osc_co60: true, osc_co70: true, osc_co71: true, osc_co72: true, osc_co73: true, osc_co80: true,
    osc_cs10: false, osc_cs20: true, osc_cs30: true, osc_cs40: true, osc_cs50: true,
    osc_in10: true, osc_in20: false, osc_in30: true,
    osc_im10: true, osc_im20: true,
    product: p, has_osc: true, has_digisquare: false)
end
if Product.where(slug: 'commcare').empty?
  p = Product.create(name: "CommCare", slug: 'commcare', start_assessment: true) if Product.where(slug: 'commcare').empty?
  p.building_blocks << BuildingBlock.where(slug: 'client_case_management').limit(1)[0]
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: true, osc_cd30: true, osc_cd31: false, osc_cd40: true, osc_cd50: true, osc_cd60: true, osc_cd61: false,
    osc_lc10: false, osc_lc20: true, osc_lc30: true, osc_lc40: true, osc_lc50: true, osc_lc60: true,
    osc_re10: true, osc_re30: false, osc_re40: true, osc_re50: true, osc_re60: false, osc_re70: true, osc_re80: true,
    osc_qu10: true, osc_qu11: false, osc_qu12: false, osc_qu20: true, osc_qu30: true, osc_qu40: true, osc_qu50: true, osc_qu51: false, osc_qu52: false, osc_qu60: true, osc_qu70: true, osc_qu71: true, osc_qu80: true, osc_qu90: true, osc_qu100: true,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: false, osc_co50: false, osc_co60: true, osc_co70: true, osc_co71: false, osc_co72: false, osc_co73: true, osc_co80: true,
    osc_cs10: false, osc_cs20: false, osc_cs30: false, osc_cs40: false, osc_cs50: false,
    osc_in10: false, osc_in20: false, osc_in30: true,
    osc_im10: true, osc_im20: true,
    digisquare_country_utilization: 3, digisquare_country_strategy: 2, digisquare_digital_health_interventions: 2, digisquare_source_code_accessibility: 2, digisquare_funding_and_revenue: 2,
    digisquare_developer_contributor_and_implementor_community_enga: 2, digisquare_community_governance: 1, digisquare_software_roadmap: 2, digisquare_user_documentation: 3, digisquare_multilingual_support: 3,
    digisquare_technical_documentation: 2, digisquare_software_productization: 2, digisquare_interoperability_and_data_accessibility: 2, digisquare_security: 3, digisquare_scalability: 3,
    product: p, has_osc: true, has_digisquare: true)
end
if Product.where(slug: 'dhis').empty?
  p = Product.create(name: "DHIS2", slug: 'dhis', start_assessment: true) if Product.where(slug: 'dhis').empty?
  p.building_blocks << BuildingBlock.where(slug: 'digital_registries').limit(1)[0]
  p.building_blocks << BuildingBlock.where(slug: 'reporting_and_dashboards').limit(1)[0]
  ProductAssessment.create(
    osc_cd10: false, osc_cd20: false, osc_cd21: false, osc_cd30: false, osc_cd31: false, osc_cd40: false, osc_cd50: false, osc_cd60: false, osc_cd61: false,
    osc_lc10: false, osc_lc20: false, osc_lc30: false, osc_lc40: false, osc_lc50: false, osc_lc60: false,
    osc_re10: false, osc_re30: false, osc_re40: false, osc_re50: false, osc_re60: false, osc_re70: false, osc_re80: false,
    osc_qu10: false, osc_qu11: false, osc_qu12: false, osc_qu20: false, osc_qu30: false, osc_qu40: false, osc_qu50: false, osc_qu51: false, osc_qu52: false, osc_qu60: false, osc_qu70: false, osc_qu71: false, osc_qu80: false, osc_qu90: false, osc_qu100: false,
    osc_co10: false, osc_co20: false, osc_co30: false, osc_co40: false, osc_co50: false, osc_co60: false, osc_co70: false, osc_co71: false, osc_co72: false, osc_co73: false, osc_co80: false,
    osc_cs10: false, osc_cs20: false, osc_cs30: false, osc_cs40: false, osc_cs50: false,
    osc_in10: false, osc_in20: false, osc_in30: false,
    osc_im10: false, osc_im20: false,
    digisquare_country_utilization: 3, digisquare_country_strategy: 2, digisquare_digital_health_interventions: 3, digisquare_source_code_accessibility: 3, digisquare_funding_and_revenue: 3,
    digisquare_developer_contributor_and_implementor_community_enga: 3, digisquare_community_governance: 2, digisquare_software_roadmap: 3, digisquare_user_documentation: 3, digisquare_multilingual_support: 3,
    digisquare_technical_documentation: 3, digisquare_software_productization: 2, digisquare_interoperability_and_data_accessibility: 3, digisquare_security: 3, digisquare_scalability: 3,
    product: p, has_osc: false, has_digisquare: true)
end
if Product.where(slug: 'drools').empty?
  p = Product.create(name: "Drools", slug: 'drools') if Product.where(slug: 'drools').empty?
  p.building_blocks << BuildingBlock.where(slug: 'terminology').limit(1)[0]
end
if Product.where(slug: 'drupal').empty?
  p=Product.create(name: "Drupal", slug: 'drupal') if Product.where(slug: 'drupal').empty?
  p.building_blocks << BuildingBlock.where(slug: 'content_management').limit(1)[0]
end
Product.create(name: "Global Digital Library", slug: 'global_digital_library') if Product.where(slug: 'global_digital_library').empty?
if Product.where(slug: 'ihris').empty?
  p = Product.create(name: "iHRIS", slug: 'ihris') if Product.where(slug: 'ihris').empty?
  p.building_blocks << BuildingBlock.where(slug: 'elearning').limit(1)[0]
  p.building_blocks << BuildingBlock.where(slug: 'digital_registries').limit(1)[0]
end
if Product.where(slug: 'librehealth').empty?
  p = Product.create(name: "LibreHealth", slug: 'librehealth', start_assessment: true) if Product.where(slug: 'librehealth').empty?
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: false, osc_cd30: false, osc_cd31: false, osc_cd40: true, osc_cd50: true, osc_cd60: true, osc_cd61: false,
    osc_lc10: true, osc_lc20: true, osc_lc30: true, osc_lc40: true, osc_lc50: true, osc_lc60: true,
    osc_re10: true, osc_re30: true, osc_re40: true, osc_re50: true, osc_re60: true, osc_re70: true, osc_re80: true,
    osc_qu10: true, osc_qu11: false, osc_qu12: false, osc_qu20: true, osc_qu30: true, osc_qu40: true, osc_qu50: true, osc_qu51: true, osc_qu52: true, osc_qu60: true, osc_qu70: true, osc_qu71: true, osc_qu80: true, osc_qu90: true, osc_qu100: true,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: true, osc_co50: true, osc_co60: true, osc_co70: true, osc_co71: true, osc_co72: true, osc_co73: true, osc_co80: true,
    osc_cs10: true, osc_cs20: true, osc_cs30: true, osc_cs40: true, osc_cs50: true,
    osc_in10: true, osc_in20: true, osc_in30: true,
    osc_im10: true, osc_im20: true,
    product: p, has_osc: true, has_digisquare: false)
end
Product.create(name: "MediaWiki", slug: 'mediawiki') if Product.where(slug: 'mediawiki').empty?
if Product.where(slug: 'medicmobile').empty?
  p = Product.create(name: "MedicMobile", slug: 'medicmobile', start_assessment: true) if Product.where(slug: 'medicmobile').empty?
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: false, osc_cd30: true, osc_cd31: false, osc_cd40: true, osc_cd50: true, osc_cd60: true, osc_cd61: false,
    osc_lc10: true, osc_lc20: true, osc_lc30: true, osc_lc40: true, osc_lc50: true, osc_lc60: true,
    osc_re10: false, osc_re30: true, osc_re40: false, osc_re50: true, osc_re60: false, osc_re70: true, osc_re80: true,
    osc_qu10: true, osc_qu11: false, osc_qu12: false, osc_qu20: true, osc_qu30: false, osc_qu40: true, osc_qu50: true, osc_qu51: true, osc_qu52: true, osc_qu60: false, osc_qu70: true, osc_qu71: true, osc_qu80: true, osc_qu90: true, osc_qu100: true,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: true, osc_co50: false, osc_co60: true, osc_co70: true, osc_co71: true, osc_co72: true, osc_co73: true, osc_co80: true,
    osc_cs10: false, osc_cs20: true, osc_cs30: false, osc_cs40: true, osc_cs50: true,
    osc_in10: false, osc_in20: false, osc_in30: false,
    osc_im10: true, osc_im20: true,
    product: p, has_osc: true, has_digisquare: false)
end
Product.create(name: "MET Norway Weather", slug: 'met_norway_weather') if Product.where(slug: 'met_norway_weather').empty?
if Product.where(slug: 'mhero').empty?
  p = Product.create(name: "mHero", slug: 'mhero', start_assessment: true) if Product.where(slug: 'mhero').empty?
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: false, osc_cd30: false, osc_cd31: false, osc_cd40: true, osc_cd50: true, osc_cd60: true, osc_cd61: false,
    osc_lc10: true, osc_lc20: true, osc_lc30: true, osc_lc40: true, osc_lc50: true, osc_lc60: true,
    osc_re10: true, osc_re30: false, osc_re40: true, osc_re50: false, osc_re60: true, osc_re70: false, osc_re80: true,
    osc_qu10: false, osc_qu11: false, osc_qu12: false, osc_qu20: false, osc_qu30: true, osc_qu40: false, osc_qu50: true, osc_qu51: true, osc_qu52: true, osc_qu60: false, osc_qu70: false, osc_qu71: false, osc_qu80: false, osc_qu90: false, osc_qu100: false,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: false, osc_co50: false, osc_co60: false, osc_co70: true, osc_co71: true, osc_co72: true, osc_co73: true, osc_co80: true,
    osc_cs10: false, osc_cs20: false, osc_cs30: false, osc_cs40: false, osc_cs50: true,
    osc_in10: true, osc_in20: true, osc_in30: false,
    osc_im10: true, osc_im20: true,
    digisquare_country_utilization: 2, digisquare_country_strategy: 1, digisquare_digital_health_interventions: 1, digisquare_source_code_accessibility: 2, digisquare_funding_and_revenue: 1,
    digisquare_developer_contributor_and_implementor_community_enga: 3, digisquare_community_governance: 2, digisquare_software_roadmap: 1, digisquare_user_documentation: 2, digisquare_multilingual_support: 1,
    digisquare_technical_documentation: 2, digisquare_software_productization: 2, digisquare_interoperability_and_data_accessibility: 3, digisquare_security: 2, digisquare_scalability: 3,
    product: p, has_osc: true, has_digisquare: true)
end
if Product.where(slug: 'mifos').empty?
  p = Product.create(name: "Mifos", slug: 'mifos', start_assessment: true) if Product.where(slug: 'mifos').empty?
  p.building_blocks << BuildingBlock.where(slug: 'payments').limit(1)[0]
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: false, osc_cd30: true, osc_cd31: false, osc_cd40: true, osc_cd50: true, osc_cd60: true, osc_cd61: false,
    osc_lc10: true, osc_lc20: true, osc_lc30: true, osc_lc40: true, osc_lc50: true, osc_lc60: true,
    osc_re10: true, osc_re30: true, osc_re40: true, osc_re50: true, osc_re60: true, osc_re70: true, osc_re80: true,
    osc_qu10: true, osc_qu11: true, osc_qu12: true, osc_qu20: true, osc_qu30: true, osc_qu40: true, osc_qu50: true, osc_qu51: true, osc_qu52: true, osc_qu60: true, osc_qu70: true, osc_qu71: true, osc_qu80: true, osc_qu90: true, osc_qu100: true,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: true, osc_co50: true, osc_co60: true, osc_co70: true, osc_co71: true, osc_co72: true, osc_co73: true, osc_co80: true,
    osc_cs10: true, osc_cs20: true, osc_cs30: true, osc_cs40: true, osc_cs50: true,
    osc_in10: true, osc_in20: true, osc_in30: true,
    osc_im10: true, osc_im20: true,
    product: p, has_osc: true, has_digisquare: false)
end
if Product.where(slug: 'mojaloop').empty?
  p = Product.create(name: "Mojaloop", slug: 'mojaloop' if Product.where(slug: 'mojaloop').empty?
  p.building_blocks << BuildingBlock.where(slug: 'payments').limit(1)[0]
end
if Product.where(slug: 'moodle').empty?
  p=Product.create(name: "Moodle", slug: 'moodle') if Product.where(slug: 'moodle').empty?
  p.building_blocks << BuildingBlock.where(slug: 'elearning').limit(1)[0]
end
if Product.where(slug: 'mosip').empty?
  p = Product.create(name: "MOSIP", slug: 'mosip') if Product.where(slug: 'mosip').empty?
  p.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
end
if Product.where(slug: 'motech').empty?
  p = Product.create(name: "MOTECH", slug: 'motech', start_assessment: true) if Product.where(slug: 'motech').empty?
  ProductAssessment.create(
    osc_cd10: false, osc_cd20: false, osc_cd21: false, osc_cd30: false, osc_cd31: false, osc_cd40: false, osc_cd50: false, osc_cd60: false, osc_cd61: false,
    osc_lc10: false, osc_lc20: false, osc_lc30: false, osc_lc40: false, osc_lc50: false, osc_lc60: false,
    osc_re10: false, osc_re30: false, osc_re40: false, osc_re50: false, osc_re60: false, osc_re70: false, osc_re80: false,
    osc_qu10: false, osc_qu11: false, osc_qu12: false, osc_qu20: false, osc_qu30: false, osc_qu40: false, osc_qu50: false, osc_qu51: false, osc_qu52: false, osc_qu60: false, osc_qu70: false, osc_qu71: false, osc_qu80: false, osc_qu90: false, osc_qu100: false,
    osc_co10: false, osc_co20: false, osc_co30: false, osc_co40: false, osc_co50: false, osc_co60: false, osc_co70: false, osc_co71: false, osc_co72: false, osc_co73: false, osc_co80: false,
    osc_cs10: false, osc_cs20: false, osc_cs30: false, osc_cs40: false, osc_cs50: false,
    osc_in10: false, osc_in20: false, osc_in30: false,
    osc_im10: false, osc_im20: false,
    product: p, has_osc: false, has_digisquare: false)
end
Product.create(name: "mSpray", slug: 'mspray') if Product.where(slug: 'mspray').empty?
if Product.where(slug: 'odk').empty?
  p = Product.create(name: "ODK", slug: 'odk', start_assessment: true) if Product.where(slug: 'odk').empty?
  p.building_blocks << BuildingBlock.where(slug: 'data_collection').limit(1)[0]
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: false, osc_cd30: true, osc_cd31: false, osc_cd40: true, osc_cd50: true, osc_cd60: true, osc_cd61: false,
    osc_lc10: false, osc_lc20: true, osc_lc30: true, osc_lc40: false, osc_lc50: true, osc_lc60: true,
    osc_re10: true, osc_re30: false, osc_re40: true, osc_re50: true, osc_re60: true, osc_re70: true, osc_re80: true,
    osc_qu10: true, osc_qu11: true, osc_qu12: true, osc_qu20: true, osc_qu30: true, osc_qu40: true, osc_qu50: true, osc_qu51: true, osc_qu52: true, osc_qu60: true, osc_qu70: true, osc_qu71: true, osc_qu80: true, osc_qu90: true, osc_qu100: true,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: true, osc_co50: true, osc_co60: true, osc_co70: true, osc_co71: true, osc_co72: false, osc_co73: true, osc_co80: true,
    osc_cs10: true, osc_cs20: true, osc_cs30: true, osc_cs40: true, osc_cs50: true,
    osc_in10: true, osc_in20: false, osc_in30: true,
    osc_im10: true, osc_im20: true,
    digisquare_country_utilization: 3, digisquare_country_strategy: 2, digisquare_digital_health_interventions: nil, digisquare_source_code_accessibility: 3, digisquare_funding_and_revenue: 3,
    digisquare_developer_contributor_and_implementor_community_enga: 3, digisquare_community_governance: 3, digisquare_software_roadmap: 2, digisquare_user_documentation: 2, digisquare_multilingual_support: 2,
    digisquare_technical_documentation: 2, digisquare_software_productization: 2, digisquare_interoperability_and_data_accessibility: 2, digisquare_security: 2, digisquare_scalability: 2,
    product: p, has_osc: true, has_digisquare: true)
end
Product.create(name: "Odoo/OpenERP", slug: 'odoo_openerp') if Product.where(slug: 'odoo_openerp').empty?
if Product.where(slug: 'open_concept_lab').empty?
  p = Product.create(name: "Open Concept Lab", slug: 'open_concept_lab') if Product.where(slug: 'open_concept_lab').empty?
  p.building_blocks << BuildingBlock.where(slug: 'terminology').limit(1)[0]
end
Product.create(name: "OpenCRVS", slug: 'opencrvs') if Product.where(slug: 'opencrvs').empty?
if Product.where(slug: 'openelis').empty?
  p = Product.create(name: "OpenELIS", slug: 'openelis', start_assessment: true) if Product.where(slug: 'openelis').empty?
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: false, osc_cd30: true, osc_cd31: false, osc_cd40: true, osc_cd50: true, osc_cd60: true, osc_cd61: false,
    osc_lc10: true, osc_lc20: true, osc_lc30: true, osc_lc40: true, osc_lc50: true, osc_lc60: true,
    osc_re10: true, osc_re30: true, osc_re40: true, osc_re50: true, osc_re60: true, osc_re70: true, osc_re80: true,
    osc_qu10: true, osc_qu11: false, osc_qu12: false, osc_qu20: true, osc_qu30: false, osc_qu40: true, osc_qu50: true, osc_qu51: true, osc_qu52: true, osc_qu60: true, osc_qu70: true, osc_qu71: true, osc_qu80: false, osc_qu90: false, osc_qu100: false,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: false, osc_co50: false, osc_co60: false, osc_co70: true, osc_co71: false, osc_co72: false, osc_co73: false, osc_co80: true,
    osc_cs10: true, osc_cs20: true, osc_cs30: false, osc_cs40: false, osc_cs50: false,
    osc_in10: true, osc_in20: true, osc_in30: true,
    osc_im10: true, osc_im20: true,
    product: p, has_osc: true, has_digisquare: false)
end
if Product.where(slug: 'openhim').empty?
  p = Product.create(name: "OpenHIM", slug: 'openhim', start_assessment: true) if Product.where(slug: 'openhim').empty?
  p.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: false, osc_cd30: true, osc_cd31: false, osc_cd40: true, osc_cd50: true, osc_cd60: true, osc_cd61: false,
    osc_lc10: true, osc_lc20: true, osc_lc30: true, osc_lc40: true, osc_lc50: true, osc_lc60: false,
    osc_re10: true, osc_re30: false, osc_re40: false, osc_re50: true, osc_re60: true, osc_re70: true, osc_re80: true,
    osc_qu10: true, osc_qu11: false, osc_qu12: false, osc_qu20: true, osc_qu30: false, osc_qu40: true, osc_qu50: true, osc_qu51: true, osc_qu52: true, osc_qu60: true, osc_qu70: true, osc_qu71: true, osc_qu80: false, osc_qu90: false, osc_qu100: false,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: true, osc_co50: true, osc_co60: true, osc_co70: true, osc_co71: true, osc_co72: true, osc_co73: true, osc_co80: true,
    osc_cs10: false, osc_cs20: true, osc_cs30: false, osc_cs40: false, osc_cs50: true,
    osc_in10: false, osc_in20: false, osc_in30: false,
    osc_im10: true, osc_im20: true,
    product: p, has_osc: true, has_digisquare: false)
end
Product.create(name: "OpenIMIS", slug: 'openimis') if Product.where(slug: 'openimis').empty?
if Product.where(slug: 'openlmis').empty?
  p = Product.create(name: "OpenLMIS", slug: 'openlmis', start_assessment: true) if Product.where(slug: 'openlmis').empty?
  p.building_blocks << BuildingBlock.where(slug: 'analytics_and_business_intel').limit(1)[0]
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: false, osc_cd30: true, osc_cd31: false, osc_cd40: true, osc_cd50: true, osc_cd60: true, osc_cd61: false,
    osc_lc10: true, osc_lc20: true, osc_lc30: true, osc_lc40: true, osc_lc50: true, osc_lc60: true,
    osc_re10: true, osc_re30: true, osc_re40: true, osc_re50: true, osc_re60: false, osc_re70: true, osc_re80: true,
    osc_qu10: true, osc_qu11: false, osc_qu12: false, osc_qu20: true, osc_qu30: false, osc_qu40: true, osc_qu50: true, osc_qu51: true, osc_qu52: true, osc_qu60: true, osc_qu70: true, osc_qu71: true, osc_qu80: true, osc_qu90: true, osc_qu100: false,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: true, osc_co50: false, osc_co60: true, osc_co70: true, osc_co71: true, osc_co72: true, osc_co73: true, osc_co80: true,
    osc_cs10: false, osc_cs20: false, osc_cs30: true, osc_cs40: false, osc_cs50: true,
    osc_in10: true, osc_in20: false, osc_in30: true,
    osc_im10: true, osc_im20: true,
    digisquare_country_utilization: 2, digisquare_country_strategy: 2, digisquare_digital_health_interventions: 3, digisquare_source_code_accessibility: 3, digisquare_funding_and_revenue: 2,
    digisquare_developer_contributor_and_implementor_community_enga: 2, digisquare_community_governance: 2, digisquare_software_roadmap: 3, digisquare_user_documentation: 2, digisquare_multilingual_support: 3,
    digisquare_technical_documentation: 2, digisquare_software_productization: 2, digisquare_interoperability_and_data_accessibility: 2, digisquare_security: 3, digisquare_scalability: 3,
    product: p, has_osc: true, has_digisquare: true)
end
if Product.where(slug: 'openmrs').empty?
  p = Product.create(name: "OpenMRS", slug: 'openmrs', start_assessment: true) if Product.where(slug: 'openmrs').empty?
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: false, osc_cd30: true, osc_cd31: false, osc_cd40: true, osc_cd50: true, osc_cd60: true, osc_cd61: false,
    osc_lc10: true, osc_lc20: true, osc_lc30: true, osc_lc40: true, osc_lc50: true, osc_lc60: true,
    osc_re10: true, osc_re30: true, osc_re40: true, osc_re50: true, osc_re60: true, osc_re70: true, osc_re80: true,
    osc_qu10: true, osc_qu11: false, osc_qu12: false, osc_qu20: true, osc_qu30: true, osc_qu40: true, osc_qu50: true, osc_qu51: true, osc_qu52: true, osc_qu60: true, osc_qu70: true, osc_qu71: true, osc_qu80: true, osc_qu90: true, osc_qu100: true,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: true, osc_co50: true, osc_co60: true, osc_co70: true, osc_co71: true, osc_co72: true, osc_co73: true, osc_co80: true,
    osc_cs10: true, osc_cs20: true, osc_cs30: true, osc_cs40: true, osc_cs50: true,
    osc_in10: true, osc_in20: true, osc_in30: true,
    osc_im10: true, osc_im20: true,
    digisquare_country_utilization: 3, digisquare_country_strategy: 2, digisquare_digital_health_interventions: 2, digisquare_source_code_accessibility: 3, digisquare_funding_and_revenue: 2,
    digisquare_developer_contributor_and_implementor_community_enga: 3, digisquare_community_governance: 3, digisquare_software_roadmap: 2, digisquare_user_documentation: 2, digisquare_multilingual_support: 2,
    digisquare_technical_documentation: 2, digisquare_software_productization: 2, digisquare_interoperability_and_data_accessibility: 2, digisquare_security: 2, digisquare_scalability: 2,
    product: p, has_osc: true, has_digisquare: true)
end
if Product.where(slug: 'opensrp').empty?
  p = Product.create(name: "OpenSRP", slug: 'opensrp', start_assessment: true) if Product.where(slug: 'opensrp').empty?
  p.building_blocks << BuildingBlock.where(slug: 'data_collection').limit(1)[0]
  p.building_blocks << BuildingBlock.where(slug: 'registration').limit(1)[0]
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: false, osc_cd30: true, osc_cd31: false, osc_cd40: true, osc_cd50: true, osc_cd60: true, osc_cd61: false,
    osc_lc10: false, osc_lc20: true, osc_lc30: true, osc_lc40: false, osc_lc50: true, osc_lc60: true,
    osc_re10: true, osc_re30: false, osc_re40: true, osc_re50: true, osc_re60: true, osc_re70: false, osc_re80: true,
    osc_qu10: true, osc_qu11: false, osc_qu12: false, osc_qu20: true, osc_qu30: true, osc_qu40: true, osc_qu50: true, osc_qu51: false, osc_qu52: false, osc_qu60: true, osc_qu70: true, osc_qu71: true, osc_qu80: true, osc_qu90: true, osc_qu100: true,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: true, osc_co50: true, osc_co60: true, osc_co70: true, osc_co71: true, osc_co72: true, osc_co73: true, osc_co80: true,
    osc_cs10: true, osc_cs20: true, osc_cs30: false, osc_cs40: true, osc_cs50: true,
    osc_in10: true, osc_in20: true, osc_in30: true,
    osc_im10: true, osc_im20: true,
    product: p, has_osc: true, has_digisquare: false)
end
Product.create(name: "OpenStreetMap", slug: 'openstreetmap') if Product.where(slug: 'openstreetmap').empty?
if Product.where(slug: 'publiclab').empty?
  p = Product.create(name: "PublicLab", slug: 'publiclab', start_assessment: true) if Product.where(slug: 'publiclab').empty?
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: false, osc_cd30: true, osc_cd31: false, osc_cd40: true, osc_cd50: true, osc_cd60: true, osc_cd61: false,
    osc_lc10: true, osc_lc20: true, osc_lc30: true, osc_lc40: true, osc_lc50: true, osc_lc60: true,
    osc_re10: true, osc_re30: true, osc_re40: true, osc_re50: true, osc_re60: true, osc_re70: true, osc_re80: true,
    osc_qu10: true, osc_qu11: false, osc_qu12: false, osc_qu20: true, osc_qu30: true, osc_qu40: true, osc_qu50: true, osc_qu51: true, osc_qu52: true, osc_qu60: true, osc_qu70: true, osc_qu71: true, osc_qu80: true, osc_qu90: true, osc_qu100: true,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: true, osc_co50: true, osc_co60: true, osc_co70: true, osc_co71: true, osc_co72: true, osc_co73: true, osc_co80: true,
    osc_cs10: true, osc_cs20: true, osc_cs30: false, osc_cs40: false, osc_cs50: true,
    osc_in10: false, osc_in20: false, osc_in30: false,
    osc_im10: true, osc_im20: true,
    product: p, has_osc: true, has_digisquare: false)
end
if Product.where(slug: 'quantum_gis').empty?
  p = Product.create(name: "Quantum GIS", slug: 'quantum_gis') if Product.where(slug: 'quantum_gis').empty?
  p.building_blocks << BuildingBlock.where(slug: 'geographic_information_services').limit(1)[0]
end
if Product.where(slug: 'rapidpro').empty?
  p = Product.create(name: "RapidPro", slug: 'rapidpro', start_assessment: true) if Product.where(slug: 'rapidpro').empty?
  p.building_blocks << BuildingBlock.where(slug: 'data_collection').limit(1)[0]
  p.building_blocks << BuildingBlock.where(slug: 'messaging').limit(1)[0]
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: false, osc_cd30: true, osc_cd31: false, osc_cd40: true, osc_cd50: true, osc_cd60: true, osc_cd61: false,
    osc_lc10: true, osc_lc20: true, osc_lc30: true, osc_lc40: true, osc_lc50: true, osc_lc60: true,
    osc_re10: true, osc_re30: true, osc_re40: true, osc_re50: true, osc_re60: false, osc_re70: true, osc_re80: true,
    osc_qu10: true, osc_qu11: false, osc_qu12: false, osc_qu20: true, osc_qu30: true, osc_qu40: true, osc_qu50: true, osc_qu51: true, osc_qu52: false, osc_qu60: true, osc_qu70: true, osc_qu71: true, osc_qu80: true, osc_qu90: true, osc_qu100: true,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: true, osc_co50: false, osc_co60: true, osc_co70: true, osc_co71: true, osc_co72: true, osc_co73: true, osc_co80: true,
    osc_cs10: true, osc_cs20: true, osc_cs30: false, osc_cs40: true, osc_cs50: false,
    osc_in10: true, osc_in20: true, osc_in30: true,
    osc_im10: true, osc_im20: true,
    product: p, has_osc: true, has_digisquare: false)
end
if Product.where(slug: 'syncope').empty?
  p = Product.create(name: "Apache Syncope", slug: 'syncope') if Product.where(slug: 'syncope').empty?
  p.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
end
if Product.where(slug: 'tensorflow').empty?
  p= Product.create(name: "TensorFlow", slug: 'tensorflow') if Product.where(slug: 'tensorflow').empty?
  p.building_blocks << BuildingBlock.where(slug: 'artificial_intelligence').limit(1)[0]
end
Product.create(name: "U-Report", slug: 'u-report') if Product.where(slug: 'u-report').empty?
if Product.where(slug: 'ushahidi').empty?
  p = Product.create(name: "Ushahidi", slug: 'ushahidi', start_assessment: true) if Product.where(slug: 'ushahidi').empty?
  ProductAssessment.create(
    osc_cd10: true, osc_cd20: true, osc_cd21: false, osc_cd30: true, osc_cd31: false, osc_cd40: true, osc_cd50: false, osc_cd60: true, osc_cd61: false,
    osc_lc10: true, osc_lc20: true, osc_lc30: false, osc_lc40: true, osc_lc50: true, osc_lc60: true,
    osc_re10: true, osc_re30: true, osc_re40: false, osc_re50: false, osc_re60: false, osc_re70: true, osc_re80: true,
    osc_qu10: true, osc_qu11: false, osc_qu12: false, osc_qu20: true, osc_qu30: false, osc_qu40: false, osc_qu50: false, osc_qu51: true, osc_qu52: true, osc_qu60: true, osc_qu70: true, osc_qu71: true, osc_qu80: false, osc_qu90: true, osc_qu100: false,
    osc_co10: true, osc_co20: true, osc_co30: true, osc_co40: false, osc_co50: false, osc_co60: false, osc_co70: true, osc_co71: true, osc_co72: false, osc_co73: true, osc_co80: false,
    osc_cs10: false, osc_cs20: false, osc_cs30: false, osc_cs40: false, osc_cs50: false,
    osc_in10: true, osc_in20: false, osc_in30: false,
    osc_im10: true, osc_im20: true,
    product: p, has_osc: true, has_digisquare: false)
end
Product.create(name: "wikiHow", slug: 'wikihow') if Product.where(slug: 'wikihow').empty?
Product.create(name: "Wikipedia", slug: 'wikipedia') if Product.where(slug: 'wikipedia').empty?
if Product.where(slug: 'wordpress').empty?
  p=Product.create(name: "WordPress", slug: 'wordpress') if Product.where(slug: 'wordpress').empty?
  p.building_blocks << BuildingBlock.where(slug: 'content_management').limit(1)[0]
end
p = Product.where(slug: 'bahmni')[0]
p.includes = Product.where(slug: ['odoo_openerp','openelis','openmrs',])
p.interoperates_with = Product.where(slug: ['dhis',])
p = Product.where(slug: 'mhero')[0]
p.includes = Product.where(slug: ['dhis','ihris','rapidpro',])
p = Product.where(slug: 'motech')[0]
p.interoperates_with = Product.where(slug: ['commcare','dhis','openmrs',])
p = Product.where(slug: 'openlmis')[0]
p.interoperates_with = Product.where(slug: ['commcare','dhis','openmrs',])
p = Product.where(slug: 'openmrs')[0]
p.interoperates_with = Product.where(slug: ['open_concept_lab',])
p = Product.where(slug: 'opensrp')[0]
p.includes = Product.where(slug: ['dhis','openlmis','openmrs','rapidpro',])

