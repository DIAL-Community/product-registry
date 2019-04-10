Product.create(name: "Bahmni", slug: 'bahmni') if Product.where(slug: 'bahmni').empty?
Product.create(name: "CommCare", slug: 'commcare') if Product.where(slug: 'commcare').empty?
if Product.where(slug: 'dhis2').empty?
  p = Product.create(name: "DHIS2", slug: 'dhis2') if Product.where(slug: 'dhis2').empty?
  p.building_blocks << BuildingBlock.where(slug: 'digital_registries').limit(1)[0]
end
Product.create(name: "Drupal", slug: 'drupal') if Product.where(slug: 'drupal').empty?
Product.create(name: "Energydata.info", slug: 'energydata.info') if Product.where(slug: 'energydata.info').empty?
Product.create(name: "Global Digital Library", slug: 'global_digital_library') if Product.where(slug: 'global_digital_library').empty?
Product.create(name: "Google TensorFlow", slug: 'google_tensorflow') if Product.where(slug: 'google_tensorflow').empty?
if Product.where(slug: 'ihris').empty?
  p = Product.create(name: "iHRIS", slug: 'ihris') if Product.where(slug: 'ihris').empty?
  p.building_blocks << BuildingBlock.where(slug: 'elearning').limit(1)[0]
end
Product.create(name: "Khan Academy", slug: 'khan_academy') if Product.where(slug: 'khan_academy').empty?
Product.create(name: "LibreHealth", slug: 'librehealth') if Product.where(slug: 'librehealth').empty?
Product.create(name: "MediaWiki", slug: 'mediawiki') if Product.where(slug: 'mediawiki').empty?
Product.create(name: "MedicMobile", slug: 'medicmobile') if Product.where(slug: 'medicmobile').empty?
Product.create(name: "MET Norway Weather", slug: 'met_norway_weather') if Product.where(slug: 'met_norway_weather').empty?
Product.create(name: "mHero", slug: 'mhero') if Product.where(slug: 'mhero').empty?
if Product.where(slug: 'mifos').empty?
  p = Product.create(name: "Mifos", slug: 'mifos') if Product.where(slug: 'mifos').empty?
  p.building_blocks << BuildingBlock.where(slug: 'elearning').limit(1)[0]
  p.building_blocks << BuildingBlock.where(slug: 'payments').limit(1)[0]
end
Product.create(name: "MIT OpenSourceWare", slug: 'mit_opensourceware') if Product.where(slug: 'mit_opensourceware').empty?
Product.create(name: "Moodle", slug: 'moodle') if Product.where(slug: 'moodle').empty?
Product.create(name: "mSpray", slug: 'mspray') if Product.where(slug: 'mspray').empty?
Product.create(name: "ODK", slug: 'odk') if Product.where(slug: 'odk').empty?
Product.create(name: "Odoo/OpenERP", slug: 'odoo/openerp') if Product.where(slug: 'odoo/openerp').empty?
Product.create(name: "Open Concept Lab", slug: 'open_concept_lab') if Product.where(slug: 'open_concept_lab').empty?
Product.create(name: "OpenCRVS", slug: 'opencrvs') if Product.where(slug: 'opencrvs').empty?
Product.create(name: "OpenELIS", slug: 'openelis') if Product.where(slug: 'openelis').empty?
Product.create(name: "OpenHIM", slug: 'openhim') if Product.where(slug: 'openhim').empty?
Product.create(name: "OpenIMIS", slug: 'openimis') if Product.where(slug: 'openimis').empty?
Product.create(name: "OpenLMIS", slug: 'openlmis') if Product.where(slug: 'openlmis').empty?
Product.create(name: "OpenMRS", slug: 'openmrs') if Product.where(slug: 'openmrs').empty?
if Product.where(slug: 'opensrp').empty?
  p = Product.create(name: "OpenSRP", slug: 'opensrp') if Product.where(slug: 'opensrp').empty?
  p.building_blocks << BuildingBlock.where(slug: 'data_collection').limit(1)[0]
  p.building_blocks << BuildingBlock.where(slug: 'registration').limit(1)[0]
end
Product.create(name: "OpenStreetMap", slug: 'openstreetmap') if Product.where(slug: 'openstreetmap').empty?
Product.create(name: "PublicLab", slug: 'publiclab') if Product.where(slug: 'publiclab').empty?
Product.create(name: "Quantum GIS", slug: 'quantum_gis') if Product.where(slug: 'quantum_gis').empty?
if Product.where(slug: 'rapidpro').empty?
  p = Product.create(name: "RapidPro", slug: 'rapidpro') if Product.where(slug: 'rapidpro').empty?
  p.building_blocks << BuildingBlock.where(slug: 'data_collection').limit(1)[0]
  p.building_blocks << BuildingBlock.where(slug: 'messaging').limit(1)[0]
end
Product.create(name: "TensorFlow", slug: 'tensorflow') if Product.where(slug: 'tensorflow').empty?
Product.create(name: "U-Report", slug: 'u-report') if Product.where(slug: 'u-report').empty?
Product.create(name: "Ushahidi", slug: 'ushahidi') if Product.where(slug: 'ushahidi').empty?
Product.create(name: "wikiHow", slug: 'wikihow') if Product.where(slug: 'wikihow').empty?
Product.create(name: "Wikipedia", slug: 'wikipedia') if Product.where(slug: 'wikipedia').empty?
Product.create(name: "WordPress", slug: 'wordpress') if Product.where(slug: 'wordpress').empty?
