connection = ActiveRecord::Base.connection()
Sector.create(name: "Advocacy", slug: 'advocacy', is_displayable: true) if Sector.where(slug: 'advocacy').empty?
Sector.create(name: "Agriculture", slug: 'agriculture', is_displayable: true) if Sector.where(slug: 'agriculture').empty?
Sector.create(name: "Anti-corruption", slug: 'anticorruption', is_displayable: false) if Sector.where(slug: 'anticorruption').empty?
Sector.create(name: "Big Data", slug: 'big_data', is_displayable: false) if Sector.where(slug: 'big_data').empty?
Sector.create(name: "Business Advocacy", slug: 'business_advocacy', is_displayable: false) if Sector.where(slug: 'business_advocacy').empty?
Sector.create(name: "Capacity Development", slug: 'capacity_development', is_displayable: false) if Sector.where(slug: 'capacity_development').empty?
Sector.create(name: "Centers of Excellence", slug: 'centers_of_excellence', is_displayable: false) if Sector.where(slug: 'centers_of_excellence').empty?
Sector.create(name: "Civil society", slug: 'civil_society', is_displayable: false) if Sector.where(slug: 'civil_society').empty?
Sector.create(name: "Climate", slug: 'climate', is_displayable: false) if Sector.where(slug: 'climate').empty?
Sector.create(name: "Communication", slug: 'communication', is_displayable: false) if Sector.where(slug: 'communication').empty?
Sector.create(name: "Conflict Resolution", slug: 'conflict_resolution', is_displayable: false) if Sector.where(slug: 'conflict_resolution').empty?
Sector.create(name: "Consulting", slug: 'consulting', is_displayable: false) if Sector.where(slug: 'consulting').empty?
Sector.create(name: "Corporate Partnerships", slug: 'corporate_partnerships', is_displayable: false) if Sector.where(slug: 'corporate_partnerships').empty?
Sector.create(name: "Corporation and Business Management", slug: 'corporation_and_business_managem', is_displayable: true) if Sector.where(slug: 'corporation_and_business_managem').empty?
Sector.create(name: "Data Collection", slug: 'data_collection', is_displayable: false) if Sector.where(slug: 'data_collection').empty?
Sector.create(name: "Data Management & Policy", slug: 'data_management__policy', is_displayable: false) if Sector.where(slug: 'data_management__policy').empty?
Sector.create(name: "Data Security", slug: 'data_security', is_displayable: false) if Sector.where(slug: 'data_security').empty?
Sector.create(name: "Demobilization & Reintegration", slug: 'demobilization__reintegration', is_displayable: false) if Sector.where(slug: 'demobilization__reintegration').empty?
Sector.create(name: "Democracy", slug: 'democracy', is_displayable: false) if Sector.where(slug: 'democracy').empty?
Sector.create(name: "Development Impact", slug: 'development_impact', is_displayable: false) if Sector.where(slug: 'development_impact').empty?
Sector.create(name: "Digital Development", slug: 'digital_development', is_displayable: false) if Sector.where(slug: 'digital_development').empty?
Sector.create(name: "Digital/Data/Tech", slug: 'digitaldatatech', is_displayable: true) if Sector.where(slug: 'digitaldatatech').empty?
Sector.create(name: "Disarmament", slug: 'disarmament', is_displayable: false) if Sector.where(slug: 'disarmament').empty?
Sector.create(name: "Economics/Finance", slug: 'economicsfinance', is_displayable: true) if Sector.where(slug: 'economicsfinance').empty?
Sector.create(name: "Education", slug: 'education', is_displayable: true) if Sector.where(slug: 'education').empty?
Sector.create(name: "Emergency Response", slug: 'emergency_response', is_displayable: false) if Sector.where(slug: 'emergency_response').empty?
Sector.create(name: "Employment", slug: 'employment', is_displayable: false) if Sector.where(slug: 'employment').empty?
Sector.create(name: "Energy", slug: 'energy', is_displayable: true) if Sector.where(slug: 'energy').empty?
Sector.create(name: "Engineering", slug: 'engineering', is_displayable: false) if Sector.where(slug: 'engineering').empty?
Sector.create(name: "Enterprise Ecosystems", slug: 'enterprise_ecosystems', is_displayable: false) if Sector.where(slug: 'enterprise_ecosystems').empty?
Sector.create(name: "Entertainment", slug: 'entertainment', is_displayable: false) if Sector.where(slug: 'entertainment').empty?
Sector.create(name: "Environment", slug: 'environment', is_displayable: true) if Sector.where(slug: 'environment').empty?
Sector.create(name: "Fair & Responsible Media", slug: 'fair__responsible_media', is_displayable: false) if Sector.where(slug: 'fair__responsible_media').empty?
Sector.create(name: "Female Genital Mutilation", slug: 'female_genital_mutilation', is_displayable: false) if Sector.where(slug: 'female_genital_mutilation').empty?
Sector.create(name: "Food", slug: 'food', is_displayable: false) if Sector.where(slug: 'food').empty?
Sector.create(name: "Fragile States", slug: 'fragile_states', is_displayable: false) if Sector.where(slug: 'fragile_states').empty?
Sector.create(name: "Gender and Minority Groups", slug: 'gender_and_minority_groups', is_displayable: true) if Sector.where(slug: 'gender_and_minority_groups').empty?
Sector.create(name: "Governance", slug: 'governance', is_displayable: true) if Sector.where(slug: 'governance').empty?
Sector.create(name: "Health", slug: 'health', is_displayable: true) if Sector.where(slug: 'health').empty?
Sector.create(name: "Humanitarian", slug: 'humanitarian', is_displayable: true) if Sector.where(slug: 'humanitarian').empty?
Sector.create(name: "Hunger", slug: 'hunger', is_displayable: false) if Sector.where(slug: 'hunger').empty?
Sector.create(name: "Infrastructure", slug: 'infrastructure', is_displayable: false) if Sector.where(slug: 'infrastructure').empty?
Sector.create(name: "Justice", slug: 'justice', is_displayable: false) if Sector.where(slug: 'justice').empty?
Sector.create(name: "Livelihoods", slug: 'livelihoods', is_displayable: false) if Sector.where(slug: 'livelihoods').empty?
Sector.create(name: "Logistics", slug: 'logistics', is_displayable: false) if Sector.where(slug: 'logistics').empty?
Sector.create(name: "Management", slug: 'management', is_displayable: false) if Sector.where(slug: 'management').empty?
Sector.create(name: "Media", slug: 'media', is_displayable: true) if Sector.where(slug: 'media').empty?
Sector.create(name: "Membership Associations", slug: 'membership_associations', is_displayable: true) if Sector.where(slug: 'membership_associations').empty?
Sector.create(name: "Midwifery", slug: 'midwifery', is_displayable: false) if Sector.where(slug: 'midwifery').empty?
Sector.create(name: "Natural Resource Conflicts", slug: 'natural_resource_conflicts', is_displayable: false) if Sector.where(slug: 'natural_resource_conflicts').empty?
Sector.create(name: "NGO", slug: 'ngo', is_displayable: false) if Sector.where(slug: 'ngo').empty?
Sector.create(name: "Nutrition", slug: 'nutrition', is_displayable: false) if Sector.where(slug: 'nutrition').empty?
Sector.create(name: "Peace", slug: 'peace', is_displayable: false) if Sector.where(slug: 'peace').empty?
Sector.create(name: "Platform creation", slug: 'platform_creation', is_displayable: false) if Sector.where(slug: 'platform_creation').empty?
Sector.create(name: "Religious Engagement", slug: 'religious_engagement', is_displayable: true) if Sector.where(slug: 'religious_engagement').empty?
Sector.create(name: "Research", slug: 'research', is_displayable: true) if Sector.where(slug: 'research').empty?
Sector.create(name: "Resource Management", slug: 'resource_management', is_displayable: false) if Sector.where(slug: 'resource_management').empty?
Sector.create(name: "Security", slug: 'security', is_displayable: false) if Sector.where(slug: 'security').empty?
Sector.create(name: "Stability", slug: 'stability', is_displayable: false) if Sector.where(slug: 'stability').empty?
Sector.create(name: "Supply Chain Solutions", slug: 'supply_chain_solutions', is_displayable: false) if Sector.where(slug: 'supply_chain_solutions').empty?
Sector.create(name: "Sustainability", slug: 'sustainability', is_displayable: false) if Sector.where(slug: 'sustainability').empty?
Sector.create(name: "Sustainable Cities", slug: 'sustainable_cities', is_displayable: false) if Sector.where(slug: 'sustainable_cities').empty?
Sector.create(name: "Training & Employment", slug: 'training__employment', is_displayable: false) if Sector.where(slug: 'training__employment').empty?
Sector.create(name: "Transition", slug: 'transition', is_displayable: false) if Sector.where(slug: 'transition').empty?
Sector.create(name: "Transparency & Accountability", slug: 'transparency__accountability', is_displayable: false) if Sector.where(slug: 'transparency__accountability').empty?
Sector.create(name: "Travel and Hospitality", slug: 'travel_and_hospitality', is_displayable: false) if Sector.where(slug: 'travel_and_hospitality').empty?
Sector.create(name: "Violent Extremism", slug: 'violent_extremism', is_displayable: false) if Sector.where(slug: 'violent_extremism').empty?
Sector.create(name: "Water and Sanitation", slug: 'water_and_sanitation', is_displayable: false) if Sector.where(slug: 'water_and_sanitation').empty?
Sector.create(name: "Workforce", slug: 'workforce', is_displayable: false) if Sector.where(slug: 'workforce').empty?
Sector.create(name: "World Population", slug: 'world_population', is_displayable: false) if Sector.where(slug: 'world_population').empty?
Sector.create(name: "Youth", slug: 'youth', is_displayable: true) if Sector.where(slug: 'youth').empty?

Location.create(name: "Afghanistan", slug: 'afghanistan', :location_type => :country) if Location.where(slug: 'afghanistan').empty?
Location.create(name: "Albania", slug: 'albania', :location_type => :country) if Location.where(slug: 'albania').empty?
Location.create(name: "Algeria", slug: 'algeria', :location_type => :country) if Location.where(slug: 'algeria').empty?
Location.create(name: "American Samoa", slug: 'american_samoa', :location_type => :country) if Location.where(slug: 'american_samoa').empty?
Location.create(name: "Andorra", slug: 'andorra', :location_type => :country) if Location.where(slug: 'andorra').empty?
Location.create(name: "Angola", slug: 'angola', :location_type => :country) if Location.where(slug: 'angola').empty?
Location.create(name: "Anguilla", slug: 'anguilla', :location_type => :country) if Location.where(slug: 'anguilla').empty?
Location.create(name: "Antarctica", slug: 'antarctica', :location_type => :country) if Location.where(slug: 'antarctica').empty?
Location.create(name: "Antigua and Barbuda", slug: 'antigua_and_barbuda', :location_type => :country) if Location.where(slug: 'antigua_and_barbuda').empty?
Location.create(name: "Argentina", slug: 'argentina', :location_type => :country) if Location.where(slug: 'argentina').empty?
Location.create(name: "Armenia", slug: 'armenia', :location_type => :country) if Location.where(slug: 'armenia').empty?
Location.create(name: "Aruba", slug: 'aruba', :location_type => :country) if Location.where(slug: 'aruba').empty?
Location.create(name: "Australia", slug: 'australia', :location_type => :country) if Location.where(slug: 'australia').empty?
Location.create(name: "Austria", slug: 'austria', :location_type => :country) if Location.where(slug: 'austria').empty?
Location.create(name: "Azerbaijan", slug: 'azerbaijan', :location_type => :country) if Location.where(slug: 'azerbaijan').empty?
Location.create(name: "Bahamas", slug: 'bahamas', :location_type => :country) if Location.where(slug: 'bahamas').empty?
Location.create(name: "Bahrain", slug: 'bahrain', :location_type => :country) if Location.where(slug: 'bahrain').empty?
Location.create(name: "Bangladesh", slug: 'bangladesh', :location_type => :country) if Location.where(slug: 'bangladesh').empty?
Location.create(name: "Barbados", slug: 'barbados', :location_type => :country) if Location.where(slug: 'barbados').empty?
Location.create(name: "Belarus", slug: 'belarus', :location_type => :country) if Location.where(slug: 'belarus').empty?
Location.create(name: "Belgium", slug: 'belgium', :location_type => :country) if Location.where(slug: 'belgium').empty?
Location.create(name: "Belize", slug: 'belize', :location_type => :country) if Location.where(slug: 'belize').empty?
Location.create(name: "Benin", slug: 'benin', :location_type => :country) if Location.where(slug: 'benin').empty?
Location.create(name: "Bermuda", slug: 'bermuda', :location_type => :country) if Location.where(slug: 'bermuda').empty?
Location.create(name: "Bhutan", slug: 'bhutan', :location_type => :country) if Location.where(slug: 'bhutan').empty?
Location.create(name: "Bolivia", slug: 'bolivia', :location_type => :country) if Location.where(slug: 'bolivia').empty?
Location.create(name: "Bosnia & Herzegovina", slug: 'bosnia__herzegovina', :location_type => :country) if Location.where(slug: 'bosnia__herzegovina').empty?
Location.create(name: "Botswana", slug: 'botswana', :location_type => :country) if Location.where(slug: 'botswana').empty?
Location.create(name: "Brazil", slug: 'brazil', :location_type => :country) if Location.where(slug: 'brazil').empty?
Location.create(name: "British Virgin Islands", slug: 'british_virgin_islands', :location_type => :country) if Location.where(slug: 'british_virgin_islands').empty?
Location.create(name: "Brunei", slug: 'brunei', :location_type => :country) if Location.where(slug: 'brunei').empty?
Location.create(name: "Bulgaria", slug: 'bulgaria', :location_type => :country) if Location.where(slug: 'bulgaria').empty?
Location.create(name: "Burkina Faso", slug: 'burkina_faso', :location_type => :country) if Location.where(slug: 'burkina_faso').empty?
Location.create(name: "Burundi", slug: 'burundi', :location_type => :country) if Location.where(slug: 'burundi').empty?
Location.create(name: "Cabo Verde", slug: 'cabo_verde', :location_type => :country) if Location.where(slug: 'cabo_verde').empty?
Location.create(name: "Cambodia", slug: 'cambodia', :location_type => :country) if Location.where(slug: 'cambodia').empty?
Location.create(name: "Cameroon", slug: 'cameroon', :location_type => :country) if Location.where(slug: 'cameroon').empty?
Location.create(name: "Canada", slug: 'canada', :location_type => :country) if Location.where(slug: 'canada').empty?
Location.create(name: "Cape Verde", slug: 'cape_verde', :location_type => :country) if Location.where(slug: 'cape_verde').empty?
Location.create(name: "Caribbean", slug: 'caribbean', :location_type => :country) if Location.where(slug: 'caribbean').empty?
Location.create(name: "Cayman Islands", slug: 'cayman_islands', :location_type => :country) if Location.where(slug: 'cayman_islands').empty?
Location.create(name: "Central African Republic", slug: 'central_african_republic', :location_type => :country) if Location.where(slug: 'central_african_republic').empty?
Location.create(name: "Chad", slug: 'chad', :location_type => :country) if Location.where(slug: 'chad').empty?
Location.create(name: "Chile", slug: 'chile', :location_type => :country) if Location.where(slug: 'chile').empty?
Location.create(name: "China", slug: 'china', :location_type => :country) if Location.where(slug: 'china').empty?
Location.create(name: "Colombia", slug: 'colombia', :location_type => :country) if Location.where(slug: 'colombia').empty?
Location.create(name: "Comoros", slug: 'comoros', :location_type => :country) if Location.where(slug: 'comoros').empty?
Location.create(name: "Congo", slug: 'congo', :location_type => :country) if Location.where(slug: 'congo').empty?
Location.create(name: "Cook Islands", slug: 'cook_islands', :location_type => :country) if Location.where(slug: 'cook_islands').empty?
Location.create(name: "Costa Rica", slug: 'costa_rica', :location_type => :country) if Location.where(slug: 'costa_rica').empty?
Location.create(name: "Cote d'lvoire", slug: 'cote_dlvoire', :location_type => :country) if Location.where(slug: 'cote_dlvoire').empty?
Location.create(name: "Croatia", slug: 'croatia', :location_type => :country) if Location.where(slug: 'croatia').empty?
Location.create(name: "Cuba", slug: 'cuba', :location_type => :country) if Location.where(slug: 'cuba').empty?
Location.create(name: "Cyprus", slug: 'cyprus', :location_type => :country) if Location.where(slug: 'cyprus').empty?
Location.create(name: "Czech Republic", slug: 'czech_republic', :location_type => :country) if Location.where(slug: 'czech_republic').empty?
Location.create(name: "Democratic Republic of Congo", slug: 'democratic_republic_of_congo', :location_type => :country) if Location.where(slug: 'democratic_republic_of_congo').empty?
Location.create(name: "Denmark", slug: 'denmark', :location_type => :country) if Location.where(slug: 'denmark').empty?
Location.create(name: "Djibouti", slug: 'djibouti', :location_type => :country) if Location.where(slug: 'djibouti').empty?
Location.create(name: "Dominican Republic", slug: 'dominican_republic', :location_type => :country) if Location.where(slug: 'dominican_republic').empty?
Location.create(name: "East Timor", slug: 'east_timor', :location_type => :country) if Location.where(slug: 'east_timor').empty?
Location.create(name: "Ecuador", slug: 'ecuador', :location_type => :country) if Location.where(slug: 'ecuador').empty?
Location.create(name: "Egypt", slug: 'egypt', :location_type => :country) if Location.where(slug: 'egypt').empty?
Location.create(name: "El Salvador", slug: 'el_salvador', :location_type => :country) if Location.where(slug: 'el_salvador').empty?
Location.create(name: "Equatorial Guinea", slug: 'equatorial_guinea', :location_type => :country) if Location.where(slug: 'equatorial_guinea').empty?
Location.create(name: "Eritrea", slug: 'eritrea', :location_type => :country) if Location.where(slug: 'eritrea').empty?
Location.create(name: "Estonia", slug: 'estonia', :location_type => :country) if Location.where(slug: 'estonia').empty?
Location.create(name: "Ethiopia", slug: 'ethiopia', :location_type => :country) if Location.where(slug: 'ethiopia').empty?
Location.create(name: "Falkland Islands", slug: 'falkland_islands', :location_type => :country) if Location.where(slug: 'falkland_islands').empty?
Location.create(name: "Fiji", slug: 'fiji', :location_type => :country) if Location.where(slug: 'fiji').empty?
Location.create(name: "Finland", slug: 'finland', :location_type => :country) if Location.where(slug: 'finland').empty?
Location.create(name: "France", slug: 'france', :location_type => :country) if Location.where(slug: 'france').empty?
Location.create(name: "French Guiana", slug: 'french_guiana', :location_type => :country) if Location.where(slug: 'french_guiana').empty?
Location.create(name: "French Southern and Antarctic Lands", slug: 'french_southern_and_antarctic_la', :location_type => :country) if Location.where(slug: 'french_southern_and_antarctic_la').empty?
Location.create(name: "Gabon", slug: 'gabon', :location_type => :country) if Location.where(slug: 'gabon').empty?
Location.create(name: "Gambia", slug: 'gambia', :location_type => :country) if Location.where(slug: 'gambia').empty?
Location.create(name: "Gaza", slug: 'gaza', :location_type => :country) if Location.where(slug: 'gaza').empty?
Location.create(name: "Georgia", slug: 'georgia', :location_type => :country) if Location.where(slug: 'georgia').empty?
Location.create(name: "Germany", slug: 'germany', :location_type => :country) if Location.where(slug: 'germany').empty?
Location.create(name: "Ghana", slug: 'ghana', :location_type => :country) if Location.where(slug: 'ghana').empty?
Location.create(name: "Greece", slug: 'greece', :location_type => :country) if Location.where(slug: 'greece').empty?
Location.create(name: "Greenland", slug: 'greenland', :location_type => :country) if Location.where(slug: 'greenland').empty?
Location.create(name: "Grenada", slug: 'grenada', :location_type => :country) if Location.where(slug: 'grenada').empty?
Location.create(name: "Guam", slug: 'guam', :location_type => :country) if Location.where(slug: 'guam').empty?
Location.create(name: "Guatemala", slug: 'guatemala', :location_type => :country) if Location.where(slug: 'guatemala').empty?
Location.create(name: "Guinea", slug: 'guinea', :location_type => :country) if Location.where(slug: 'guinea').empty?
Location.create(name: "Guinea Bissau", slug: 'guinea_bissau', :location_type => :country) if Location.where(slug: 'guinea_bissau').empty?
Location.create(name: "Guyana", slug: 'guyana', :location_type => :country) if Location.where(slug: 'guyana').empty?
Location.create(name: "Haiti", slug: 'haiti', :location_type => :country) if Location.where(slug: 'haiti').empty?
Location.create(name: "Honduras", slug: 'honduras', :location_type => :country) if Location.where(slug: 'honduras').empty?
Location.create(name: "Hong Kong", slug: 'hong_kong', :location_type => :country) if Location.where(slug: 'hong_kong').empty?
Location.create(name: "Hungary", slug: 'hungary', :location_type => :country) if Location.where(slug: 'hungary').empty?
Location.create(name: "Iceland", slug: 'iceland', :location_type => :country) if Location.where(slug: 'iceland').empty?
Location.create(name: "India", slug: 'india', :location_type => :country) if Location.where(slug: 'india').empty?
Location.create(name: "Indonesia", slug: 'indonesia', :location_type => :country) if Location.where(slug: 'indonesia').empty?
Location.create(name: "Iran", slug: 'iran', :location_type => :country) if Location.where(slug: 'iran').empty?
Location.create(name: "Iraq", slug: 'iraq', :location_type => :country) if Location.where(slug: 'iraq').empty?
Location.create(name: "Ireland", slug: 'ireland', :location_type => :country) if Location.where(slug: 'ireland').empty?
Location.create(name: "Israel", slug: 'israel', :location_type => :country) if Location.where(slug: 'israel').empty?
Location.create(name: "Italy", slug: 'italy', :location_type => :country) if Location.where(slug: 'italy').empty?
Location.create(name: "Jamaica", slug: 'jamaica', :location_type => :country) if Location.where(slug: 'jamaica').empty?
Location.create(name: "Japan", slug: 'japan', :location_type => :country) if Location.where(slug: 'japan').empty?
Location.create(name: "Jordan", slug: 'jordan', :location_type => :country) if Location.where(slug: 'jordan').empty?
Location.create(name: "Kazakhstan", slug: 'kazakhstan', :location_type => :country) if Location.where(slug: 'kazakhstan').empty?
Location.create(name: "Kenya", slug: 'kenya', :location_type => :country) if Location.where(slug: 'kenya').empty?
Location.create(name: "Kiribati", slug: 'kiribati', :location_type => :country) if Location.where(slug: 'kiribati').empty?
Location.create(name: "Korea", slug: 'korea', :location_type => :country) if Location.where(slug: 'korea').empty?
Location.create(name: "Kosovo", slug: 'kosovo', :location_type => :country) if Location.where(slug: 'kosovo').empty?
Location.create(name: "Kyrgystan", slug: 'kyrgystan', :location_type => :country) if Location.where(slug: 'kyrgystan').empty?
Location.create(name: "Laos", slug: 'laos', :location_type => :country) if Location.where(slug: 'laos').empty?
Location.create(name: "Latvia", slug: 'latvia', :location_type => :country) if Location.where(slug: 'latvia').empty?
Location.create(name: "Lebanon", slug: 'lebanon', :location_type => :country) if Location.where(slug: 'lebanon').empty?
Location.create(name: "Lesotho", slug: 'lesotho', :location_type => :country) if Location.where(slug: 'lesotho').empty?
Location.create(name: "Lesser Antilles", slug: 'lesser_antilles', :location_type => :country) if Location.where(slug: 'lesser_antilles').empty?
Location.create(name: "Liberia", slug: 'liberia', :location_type => :country) if Location.where(slug: 'liberia').empty?
Location.create(name: "Libya", slug: 'libya', :location_type => :country) if Location.where(slug: 'libya').empty?
Location.create(name: "Lithuania", slug: 'lithuania', :location_type => :country) if Location.where(slug: 'lithuania').empty?
Location.create(name: "Luxembourg", slug: 'luxembourg', :location_type => :country) if Location.where(slug: 'luxembourg').empty?
Location.create(name: "Macao", slug: 'macao', :location_type => :country) if Location.where(slug: 'macao').empty?
Location.create(name: "Macedonia", slug: 'macedonia', :location_type => :country) if Location.where(slug: 'macedonia').empty?
Location.create(name: "Madagascar", slug: 'madagascar', :location_type => :country) if Location.where(slug: 'madagascar').empty?
Location.create(name: "Malawi", slug: 'malawi', :location_type => :country) if Location.where(slug: 'malawi').empty?
Location.create(name: "Malaysia", slug: 'malaysia', :location_type => :country) if Location.where(slug: 'malaysia').empty?
Location.create(name: "Maldives", slug: 'maldives', :location_type => :country) if Location.where(slug: 'maldives').empty?
Location.create(name: "Maldova", slug: 'maldova', :location_type => :country) if Location.where(slug: 'maldova').empty?
Location.create(name: "Mali", slug: 'mali', :location_type => :country) if Location.where(slug: 'mali').empty?
Location.create(name: "Malta", slug: 'malta', :location_type => :country) if Location.where(slug: 'malta').empty?
Location.create(name: "Marshall Islands", slug: 'marshall_islands', :location_type => :country) if Location.where(slug: 'marshall_islands').empty?
Location.create(name: "Mauritania", slug: 'mauritania', :location_type => :country) if Location.where(slug: 'mauritania').empty?
Location.create(name: "Mauritius", slug: 'mauritius', :location_type => :country) if Location.where(slug: 'mauritius').empty?
Location.create(name: "Mexico", slug: 'mexico', :location_type => :country) if Location.where(slug: 'mexico').empty?
Location.create(name: "Micronesia", slug: 'micronesia', :location_type => :country) if Location.where(slug: 'micronesia').empty?
Location.create(name: "Moldova", slug: 'moldova', :location_type => :country) if Location.where(slug: 'moldova').empty?
Location.create(name: "Monaco", slug: 'monaco', :location_type => :country) if Location.where(slug: 'monaco').empty?
Location.create(name: "Mongolia", slug: 'mongolia', :location_type => :country) if Location.where(slug: 'mongolia').empty?
Location.create(name: "Montenegro", slug: 'montenegro', :location_type => :country) if Location.where(slug: 'montenegro').empty?
Location.create(name: "Montserrat", slug: 'montserrat', :location_type => :country) if Location.where(slug: 'montserrat').empty?
Location.create(name: "Morocco", slug: 'morocco', :location_type => :country) if Location.where(slug: 'morocco').empty?
Location.create(name: "Mozambique", slug: 'mozambique', :location_type => :country) if Location.where(slug: 'mozambique').empty?
Location.create(name: "Myanmar", slug: 'myanmar', :location_type => :country) if Location.where(slug: 'myanmar').empty?
Location.create(name: "Namibia", slug: 'namibia', :location_type => :country) if Location.where(slug: 'namibia').empty?
Location.create(name: "Nauru", slug: 'nauru', :location_type => :country) if Location.where(slug: 'nauru').empty?
Location.create(name: "Nepal", slug: 'nepal', :location_type => :country) if Location.where(slug: 'nepal').empty?
Location.create(name: "Netherlands", slug: 'netherlands', :location_type => :country) if Location.where(slug: 'netherlands').empty?
Location.create(name: "New Caledonia", slug: 'new_caledonia', :location_type => :country) if Location.where(slug: 'new_caledonia').empty?
Location.create(name: "New Guinea", slug: 'new_guinea', :location_type => :country) if Location.where(slug: 'new_guinea').empty?
Location.create(name: "New Zealand", slug: 'new_zealand', :location_type => :country) if Location.where(slug: 'new_zealand').empty?
Location.create(name: "Nicaragua", slug: 'nicaragua', :location_type => :country) if Location.where(slug: 'nicaragua').empty?
Location.create(name: "Niger", slug: 'niger', :location_type => :country) if Location.where(slug: 'niger').empty?
Location.create(name: "Nigeria", slug: 'nigeria', :location_type => :country) if Location.where(slug: 'nigeria').empty?
Location.create(name: "Niue", slug: 'niue', :location_type => :country) if Location.where(slug: 'niue').empty?
Location.create(name: "Norfolk Island", slug: 'norfolk_island', :location_type => :country) if Location.where(slug: 'norfolk_island').empty?
Location.create(name: "North Korea", slug: 'north_korea', :location_type => :country) if Location.where(slug: 'north_korea').empty?
Location.create(name: "Northern Cyprus", slug: 'northern_cyprus', :location_type => :country) if Location.where(slug: 'northern_cyprus').empty?
Location.create(name: "Northern Mariana Islands", slug: 'northern_mariana_islands', :location_type => :country) if Location.where(slug: 'northern_mariana_islands').empty?
Location.create(name: "Norway", slug: 'norway', :location_type => :country) if Location.where(slug: 'norway').empty?
Location.create(name: "Oman", slug: 'oman', :location_type => :country) if Location.where(slug: 'oman').empty?
Location.create(name: "Pakistan", slug: 'pakistan', :location_type => :country) if Location.where(slug: 'pakistan').empty?
Location.create(name: "Palau", slug: 'palau', :location_type => :country) if Location.where(slug: 'palau').empty?
Location.create(name: "Palestine", slug: 'palestine', :location_type => :country) if Location.where(slug: 'palestine').empty?
Location.create(name: "Panama", slug: 'panama', :location_type => :country) if Location.where(slug: 'panama').empty?
Location.create(name: "Papua New Guinea", slug: 'papua_new_guinea', :location_type => :country) if Location.where(slug: 'papua_new_guinea').empty?
Location.create(name: "Paraguay", slug: 'paraguay', :location_type => :country) if Location.where(slug: 'paraguay').empty?
Location.create(name: "Peru", slug: 'peru', :location_type => :country) if Location.where(slug: 'peru').empty?
Location.create(name: "Philippines", slug: 'philippines', :location_type => :country) if Location.where(slug: 'philippines').empty?
Location.create(name: "Poland", slug: 'poland', :location_type => :country) if Location.where(slug: 'poland').empty?
Location.create(name: "Portugal", slug: 'portugal', :location_type => :country) if Location.where(slug: 'portugal').empty?
Location.create(name: "Puerto Rico", slug: 'puerto_rico', :location_type => :country) if Location.where(slug: 'puerto_rico').empty?
Location.create(name: "Qatar", slug: 'qatar', :location_type => :country) if Location.where(slug: 'qatar').empty?
Location.create(name: "Romania", slug: 'romania', :location_type => :country) if Location.where(slug: 'romania').empty?
Location.create(name: "Russia", slug: 'russia', :location_type => :country) if Location.where(slug: 'russia').empty?
Location.create(name: "Rwanda", slug: 'rwanda', :location_type => :country) if Location.where(slug: 'rwanda').empty?
Location.create(name: "Saint Kitts and Nevis", slug: 'saint_kitts_and_nevis', :location_type => :country) if Location.where(slug: 'saint_kitts_and_nevis').empty?
Location.create(name: "Saint Lucia", slug: 'saint_lucia', :location_type => :country) if Location.where(slug: 'saint_lucia').empty?
Location.create(name: "Saint Vincent and the Grenadines", slug: 'saint_vincent_and_the_grenadines', :location_type => :country) if Location.where(slug: 'saint_vincent_and_the_grenadines').empty?
Location.create(name: "Samoa", slug: 'samoa', :location_type => :country) if Location.where(slug: 'samoa').empty?
Location.create(name: "San Marino", slug: 'san_marino', :location_type => :country) if Location.where(slug: 'san_marino').empty?
Location.create(name: "Sao Tome and Principe", slug: 'sao_tome_and_principe', :location_type => :country) if Location.where(slug: 'sao_tome_and_principe').empty?
Location.create(name: "Saudi Arabia", slug: 'saudi_arabia', :location_type => :country) if Location.where(slug: 'saudi_arabia').empty?
Location.create(name: "Senegal", slug: 'senegal', :location_type => :country) if Location.where(slug: 'senegal').empty?
Location.create(name: "Serbia", slug: 'serbia', :location_type => :country) if Location.where(slug: 'serbia').empty?
Location.create(name: "Seychelles", slug: 'seychelles', :location_type => :country) if Location.where(slug: 'seychelles').empty?
Location.create(name: "Sierra Leone", slug: 'sierra_leone', :location_type => :country) if Location.where(slug: 'sierra_leone').empty?
Location.create(name: "Singapore", slug: 'singapore', :location_type => :country) if Location.where(slug: 'singapore').empty?
Location.create(name: "Slovakia", slug: 'slovakia', :location_type => :country) if Location.where(slug: 'slovakia').empty?
Location.create(name: "Slovenia", slug: 'slovenia', :location_type => :country) if Location.where(slug: 'slovenia').empty?
Location.create(name: "Solomon Islands", slug: 'solomon_islands', :location_type => :country) if Location.where(slug: 'solomon_islands').empty?
Location.create(name: "Somalia", slug: 'somalia', :location_type => :country) if Location.where(slug: 'somalia').empty?
Location.create(name: "South Africa", slug: 'south_africa', :location_type => :country) if Location.where(slug: 'south_africa').empty?
Location.create(name: "South Korea", slug: 'south_korea', :location_type => :country) if Location.where(slug: 'south_korea').empty?
Location.create(name: "South Sudan", slug: 'south_sudan', :location_type => :country) if Location.where(slug: 'south_sudan').empty?
Location.create(name: "Spain", slug: 'spain', :location_type => :country) if Location.where(slug: 'spain').empty?
Location.create(name: "Sri Lanka", slug: 'sri_lanka', :location_type => :country) if Location.where(slug: 'sri_lanka').empty?
Location.create(name: "Sudan", slug: 'sudan', :location_type => :country) if Location.where(slug: 'sudan').empty?
Location.create(name: "Suriname", slug: 'suriname', :location_type => :country) if Location.where(slug: 'suriname').empty?
Location.create(name: "Swaziland", slug: 'swaziland', :location_type => :country) if Location.where(slug: 'swaziland').empty?
Location.create(name: "Sweden", slug: 'sweden', :location_type => :country) if Location.where(slug: 'sweden').empty?
Location.create(name: "Switzerland", slug: 'switzerland', :location_type => :country) if Location.where(slug: 'switzerland').empty?
Location.create(name: "Syria", slug: 'syria', :location_type => :country) if Location.where(slug: 'syria').empty?
Location.create(name: "Taiwan", slug: 'taiwan', :location_type => :country) if Location.where(slug: 'taiwan').empty?
Location.create(name: "Tajikistan", slug: 'tajikistan', :location_type => :country) if Location.where(slug: 'tajikistan').empty?
Location.create(name: "Tanzania", slug: 'tanzania', :location_type => :country) if Location.where(slug: 'tanzania').empty?
Location.create(name: "Thailand", slug: 'thailand', :location_type => :country) if Location.where(slug: 'thailand').empty?
Location.create(name: "Timor Leste", slug: 'timor_leste', :location_type => :country) if Location.where(slug: 'timor_leste').empty?
Location.create(name: "Togo", slug: 'togo', :location_type => :country) if Location.where(slug: 'togo').empty?
Location.create(name: "Tokelau", slug: 'tokelau', :location_type => :country) if Location.where(slug: 'tokelau').empty?
Location.create(name: "Tonga", slug: 'tonga', :location_type => :country) if Location.where(slug: 'tonga').empty?
Location.create(name: "Trinidad and Tobago", slug: 'trinidad_and_tobago', :location_type => :country) if Location.where(slug: 'trinidad_and_tobago').empty?
Location.create(name: "Tunisia", slug: 'tunisia', :location_type => :country) if Location.where(slug: 'tunisia').empty?
Location.create(name: "Turkey", slug: 'turkey', :location_type => :country) if Location.where(slug: 'turkey').empty?
Location.create(name: "Turkmenistan", slug: 'turkmenistan', :location_type => :country) if Location.where(slug: 'turkmenistan').empty?
Location.create(name: "Turks and Caicos Islands", slug: 'turks_and_caicos_islands', :location_type => :country) if Location.where(slug: 'turks_and_caicos_islands').empty?
Location.create(name: "Tuvalu", slug: 'tuvalu', :location_type => :country) if Location.where(slug: 'tuvalu').empty?
Location.create(name: "Uganda", slug: 'uganda', :location_type => :country) if Location.where(slug: 'uganda').empty?
Location.create(name: "Ukraine", slug: 'ukraine', :location_type => :country) if Location.where(slug: 'ukraine').empty?
Location.create(name: "United Arab Emirates", slug: 'united_arab_emirates', :location_type => :country) if Location.where(slug: 'united_arab_emirates').empty?
Location.create(name: "United Kingdom", slug: 'united_kingdom', :location_type => :country) if Location.where(slug: 'united_kingdom').empty?
Location.create(name: "United States", slug: 'united_states', :location_type => :country) if Location.where(slug: 'united_states').empty?
Location.create(name: "Uruguay", slug: 'uruguay', :location_type => :country) if Location.where(slug: 'uruguay').empty?
Location.create(name: "US Virgin Islands", slug: 'us_virgin_islands', :location_type => :country) if Location.where(slug: 'us_virgin_islands').empty?
Location.create(name: "Uzbekistan", slug: 'uzbekistan', :location_type => :country) if Location.where(slug: 'uzbekistan').empty?
Location.create(name: "Vanuatu", slug: 'vanuatu', :location_type => :country) if Location.where(slug: 'vanuatu').empty?
Location.create(name: "Venezuela", slug: 'venezuela', :location_type => :country) if Location.where(slug: 'venezuela').empty?
Location.create(name: "Vietnam", slug: 'vietnam', :location_type => :country) if Location.where(slug: 'vietnam').empty?
Location.create(name: "Western Sahara", slug: 'western_sahara', :location_type => :country) if Location.where(slug: 'western_sahara').empty?
Location.create(name: "Yemen", slug: 'yemen', :location_type => :country) if Location.where(slug: 'yemen').empty?
Location.create(name: "Zambia", slug: 'zambia', :location_type => :country) if Location.where(slug: 'zambia').empty?
Location.create(name: "Zimbabwe", slug: 'zimbabwe', :location_type => :country) if Location.where(slug: 'zimbabwe').empty?
if Organization.where(slug: 'abt_associates').empty?
  o = Organization.create(name: "Abt Associates", slug: 'abt_associates', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://abtassociates.com/")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'data_security').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'food').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'justice').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'australia').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'jamaica').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'papua_new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'turkmenistan').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'uzbekistan').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
end
if Organization.where(slug: 'aerian').empty?
  o = Organization.create(name: "Aerian", slug: 'aerian', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.aerian.com")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'platform_creation').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  l = Location.create(name: "The Old Malthouse, Mill Lane, UK", slug: 'the_old_malthouse_mill_lane_uk', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (51.4196516, -2.253189) ] WHERE slug = 'the_old_malthouse_mill_lane_uk'")
  o.locations << l
end
if Organization.where(slug: 'akros').empty?
  o = Organization.create(name: "Akros", slug: 'akros', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "www.akros.com")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
end
if Organization.where(slug: 'akryl').empty?
  o = Organization.create(name: "Akryl", slug: 'akryl', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.akryl.net ")
  o.sectors << Sector.where(slug: 'communication').limit(1)[0]
  o.sectors << Sector.where(slug: 'media').limit(1)[0]
  o.sectors << Sector.where(slug: 'media').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'germany').limit(1)[0]
  l = Location.create(name: "Beijing, China", slug: 'beijing_china', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (39.9041999, 116.4073963) ] WHERE slug = 'beijing_china'")
  o.locations << l
  l = Location.create(name: "Hamburg, Germany", slug: 'hamburg_germany', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (53.5510846, 9.9936819) ] WHERE slug = 'hamburg_germany'")
  o.locations << l
end
if Organization.where(slug: 'aptivate').empty?
  o = Organization.create(name: "Aptivate", slug: 'aptivate', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "http://www.aptivate.org/")
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
end
if Organization.where(slug: 'avallain_foundation_inc').empty?
  o = Organization.create(name: "Avallain Foundation, inc.", slug: 'avallain_foundation_inc', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "www.avallainfoundation.org")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
end
if Organization.where(slug: 'awaazde').empty?
  o = Organization.create(name: "Awaaz.De", slug: 'awaazde', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.awaaz.de/")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  l = Location.create(name: "Ahmedabad, Gujrat, India", slug: 'ahmedabad_gujrat_india', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (23.022505, 72.5713621) ] WHERE slug = 'ahmedabad_gujrat_india'")
  o.locations << l
end
if Organization.where(slug: 'belgian_development_agency').empty?
  o = Organization.create(name: "Belgian Development Agency", slug: 'belgian_development_agency', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "WWW.BTCCTB.ORG")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'employment').limit(1)[0]
  o.sectors << Sector.where(slug: 'energy').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'water_and_sanitation').limit(1)[0]
  o.locations << Location.where(slug: 'algeria').limit(1)[0]
  o.locations << Location.where(slug: 'belgium').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  l = Location.create(name: "Brussels, Belgium", slug: 'brussels_belgium', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (50.8503463, 4.3517211) ] WHERE slug = 'brussels_belgium'")
  o.locations << l
end
if Organization.where(slug: 'bill_and_melinda_gates_foundatio').empty?
  o = Organization.create(name: "Bill and Melinda Gates Foundation", slug: 'bill_and_melinda_gates_foundatio', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.gatesfoundation.org/")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'employment').limit(1)[0]
  o.sectors << Sector.where(slug: 'energy').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'water_and_sanitation').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'denmark').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'france').limit(1)[0]
  o.locations << Location.where(slug: 'germany').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'netherlands').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'norway').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'sweden').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  l = Location.create(name: "Seattle, WA", slug: 'seattle_wa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (47.6062095, -122.3320708) ] WHERE slug = 'seattle_wa'")
  o.locations << l
end
if Organization.where(slug: 'bivee').empty?
  o = Organization.create(name: "Bivee", slug: 'bivee', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.bivee.co")
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.locations << Location.where(slug: 'hong_kong').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
end
if Organization.where(slug: 'build_up').empty?
  o = Organization.create(name: "Build Up", slug: 'build_up', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://howtobuildup.org/projects/ ")
end
if Organization.where(slug: 'caktus_group').empty?
  o = Organization.create(name: "Caktus Group", slug: 'caktus_group', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.caktusgroup.com/")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'energy').limit(1)[0]
  o.sectors << Sector.where(slug: 'engineering').limit(1)[0]
  o.sectors << Sector.where(slug: 'entertainment').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'media').limit(1)[0]
  o.sectors << Sector.where(slug: 'media').limit(1)[0]
  o.sectors << Sector.where(slug: 'media').limit(1)[0]
  o.sectors << Sector.where(slug: 'membership_associations').limit(1)[0]
  o.sectors << Sector.where(slug: 'ngo').limit(1)[0]
  o.sectors << Sector.where(slug: 'research').limit(1)[0]
  o.sectors << Sector.where(slug: 'travel_and_hospitality').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  l = Location.create(name: "Durham, NC", slug: 'durham_nc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (35.9940329, -78.898619) ] WHERE slug = 'durham_nc'")
  o.locations << l
end
if Organization.where(slug: 'catholic_relief_services_crs').empty?
  o = Organization.create(name: "Catholic Relief Services (CRS)", slug: 'catholic_relief_services_crs', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.crs.org/")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'emergency_response').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'justice').limit(1)[0]
  o.sectors << Sector.where(slug: 'peace').limit(1)[0]
  o.sectors << Sector.where(slug: 'water_and_sanitation').limit(1)[0]
  o.sectors << Sector.where(slug: 'youth').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'chile').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'cuba').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'equatorial_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'gambia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'greece').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guinea_bissau').limit(1)[0]
  o.locations << Location.where(slug: 'guyana').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'israel').limit(1)[0]
  o.locations << Location.where(slug: 'jamaica').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'lesser_antilles').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'micronesia').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'russia').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Baltimore, MD", slug: 'baltimore_md', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (39.2903848, -76.6121893) ] WHERE slug = 'baltimore_md'")
  o.locations << l
end
if Organization.where(slug: 'center_for_international_private').empty?
  o = Organization.create(name: "Center for International Private Enterprise (CIPE)", slug: 'center_for_international_private', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.cipe.org/")
  o.sectors << Sector.where(slug: 'advocacy').limit(1)[0]
  o.sectors << Sector.where(slug: 'anticorruption').limit(1)[0]
  o.sectors << Sector.where(slug: 'business_advocacy').limit(1)[0]
  o.sectors << Sector.where(slug: 'centers_of_excellence').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'democracy').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'enterprise_ecosystems').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'algeria').limit(1)[0]
  o.locations << Location.where(slug: 'argentina').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'bahrain').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'papua_new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'paraguay').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'chamilo').empty?
  o = Organization.create(name: "Chamilo", slug: 'chamilo', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "www.chamilo.org")
end
if Organization.where(slug: 'charlie_goldsmith_associates').empty?
  o = Organization.create(name: "Charlie Goldsmith Associates", slug: 'charlie_goldsmith_associates', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://charliegoldsmithassociates.co.uk/")
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'food').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'management').limit(1)[0]
  o.sectors << Sector.where(slug: 'security').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  l = Location.create(name: "London, UK", slug: 'london_uk', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (51.5073509, -0.1277583) ] WHERE slug = 'london_uk'")
  o.locations << l
end
if Organization.where(slug: 'chemonics').empty?
  o = Organization.create(name: "Chemonics", slug: 'chemonics', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "www.chemonics.com")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'climate').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporate_partnerships').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'democracy').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'energy').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'peace').limit(1)[0]
  o.sectors << Sector.where(slug: 'stability').limit(1)[0]
  o.sectors << Sector.where(slug: 'supply_chain_solutions').limit(1)[0]
  o.sectors << Sector.where(slug: 'sustainable_cities').limit(1)[0]
  o.sectors << Sector.where(slug: 'transition').limit(1)[0]
  o.sectors << Sector.where(slug: 'water_and_sanitation').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'maldives').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'code_innovation').empty?
  o = Organization.create(name: "CODE Innovation", slug: 'code_innovation', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://codeinnovation.com/")
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  l = Location.create(name: "Silicon Valley?", slug: 'silicon_valley', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (37.387474, -122.0575434) ] WHERE slug = 'silicon_valley'")
  o.locations << l
end
if Organization.where(slug: 'congo_in_the_picture').empty?
  o = Organization.create(name: "Congo in the Picture", slug: 'congo_in_the_picture', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "https://www.facebook.com/CongoInThePicture/")
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
end
if Organization.where(slug: 'coopersmith').empty?
  o = Organization.create(name: "Cooper/Smith", slug: 'coopersmith', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "coopersmith.org")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'creative_associates_internationa').empty?
  o = Organization.create(name: "Creative Associates International", slug: 'creative_associates_internationa', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.creativeassociatesinternational.com/")
  o.sectors << Sector.where(slug: 'capacity_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'democracy').limit(1)[0]
  o.sectors << Sector.where(slug: 'democracy').limit(1)[0]
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'livelihoods').limit(1)[0]
  o.sectors << Sector.where(slug: 'security').limit(1)[0]
  o.sectors << Sector.where(slug: 'stability').limit(1)[0]
  o.sectors << Sector.where(slug: 'violent_extremism').limit(1)[0]
  o.sectors << Sector.where(slug: 'workforce').limit(1)[0]
  o.sectors << Sector.where(slug: 'youth').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'algeria').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'belarus').limit(1)[0]
  o.locations << Location.where(slug: 'belize').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bhutan').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'bulgaria').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'congo').limit(1)[0]
  o.locations << Location.where(slug: 'costa_rica').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'equatorial_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'gambia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guyana').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'jamaica').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'oman').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'portugal').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'russia').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'saint_kitts_and_nevis').limit(1)[0]
  o.locations << Location.where(slug: 'saint_lucia').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'slovenia').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'turkmenistan').limit(1)[0]
  o.locations << Location.where(slug: 'turkmenistan').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'uzbekistan').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'democracy_international').empty?
  o = Organization.create(name: "Democracy International", slug: 'democracy_international', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://democracyinternational.com/")
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guyana').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'jamaica').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'macedonia').limit(1)[0]
  o.locations << Location.where(slug: 'malaysia').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'montenegro').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'russia').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'venezuela').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Bethesda, MD", slug: 'bethesda_md', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.984652, -77.0947092) ] WHERE slug = 'bethesda_md'")
  o.locations << l
end
if Organization.where(slug: 'development_alternatives_incorpo').empty?
  o = Organization.create(name: "Development Alternatives Incorporated (DAI)", slug: 'development_alternatives_incorpo', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.dai.com/")
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'energy').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'fragile_states').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'sustainability').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'american_samoa').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'brunei').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'fiji').limit(1)[0]
  o.locations << Location.where(slug: 'gambia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guam').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'malaysia').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'seychelles').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'singapore').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'turkmenistan').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'uzbekistan').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Bethesda, MD", slug: 'bethesda_md', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.984652, -77.0947092) ] WHERE slug = 'bethesda_md'")
  o.locations << l
end
if Organization.where(slug: 'development_gateway').empty?
  o = Organization.create(name: "Development Gateway", slug: 'development_gateway', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "www.developmentgateway.org")
  o.sectors << Sector.where(slug: 'data_management__policy').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'canada').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'chile').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'denmark').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'gambia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'maldova').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mongolia').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'norway').limit(1)[0]
  o.locations << Location.where(slug: 'papua_new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'digital_campus').empty?
  o = Organization.create(name: "Digital Campus", slug: 'digital_campus', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://digital-campus.org/")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
end
if Organization.where(slug: 'digital_green').empty?
  o = Organization.create(name: "Digital Green", slug: 'digital_green', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.digitalgreen.org/")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  l = Location.create(name: "San Francisco, CA", slug: 'san_francisco_ca', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (37.7749295, -122.4194155) ] WHERE slug = 'san_francisco_ca'")
  o.locations << l
  l = Location.create(name: "New Delhi, India", slug: 'new_delhi_india', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (28.6139391, 77.2090212) ] WHERE slug = 'new_delhi_india'")
  o.locations << l
end
if Organization.where(slug: 'digital_impact_alliance_dial').empty?
  o = Organization.create(name: "Digital Impact Alliance (DIAL)", slug: 'digital_impact_alliance_dial', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "http://digitalimpactalliance.org/")
end
if Organization.where(slug: 'digital_opportunity_trust_dot').empty?
  o = Organization.create(name: "Digital Opportunity Trust (DOT)", slug: 'digital_opportunity_trust_dot', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "https://www.dotrust.org/")
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'youth').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'argentina').limit(1)[0]
  o.locations << Location.where(slug: 'canada').limit(1)[0]
  o.locations << Location.where(slug: 'chile').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_arab_emirates').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Ottawa, Canada", slug: 'ottawa_canada', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (45.4215296, -75.6971931) ] WHERE slug = 'ottawa_canada'")
  o.locations << l
end
if Organization.where(slug: 'dimagi').empty?
  o = Organization.create(name: "Dimagi", slug: 'dimagi', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.dimagi.com")
  o.sectors << Sector.where(slug: 'communication').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'media').limit(1)[0]
  o.sectors << Sector.where(slug: 'media').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
end
if Organization.where(slug: 'disruptive_designs').empty?
  o = Organization.create(name: "Disruptive Designs", slug: 'disruptive_designs', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "")
end
if Organization.where(slug: 'ecorys').empty?
  o = Organization.create(name: "Ecorys", slug: 'ecorys', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "https://uk.ecorys.com/")
end
if Organization.where(slug: 'education_development_center_edc').empty?
  o = Organization.create(name: "Education Development Center (EDC)", slug: 'education_development_center_edc', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.edc.org/")
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  l = Location.create(name: "Waltham (Boston), MA", slug: 'waltham_boston_ma', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (42.3764852, -71.2356113) ] WHERE slug = 'waltham_boston_ma'")
  o.locations << l
end
if Organization.where(slug: 'enabel').empty?
  o = Organization.create(name: "Enabel", slug: 'enabel', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.enabel.be")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'climate').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'energy').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'training__employment').limit(1)[0]
  o.sectors << Sector.where(slug: 'water_and_sanitation').limit(1)[0]
  o.locations << Location.where(slug: 'algeria').limit(1)[0]
  o.locations << Location.where(slug: 'belgium').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  l = Location.create(name: "Brussels, Belgium", slug: 'brussels_belgium', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (50.8503463, 4.3517211) ] WHERE slug = 'brussels_belgium'")
  o.locations << l
end
if Organization.where(slug: 'everymobile').empty?
  o = Organization.create(name: "Every1Mobile", slug: 'everymobile', when_endorsed: DateTime.new(2015, 1, 1), is_endorser: true, website: "http://www.every1mobile.net/")
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
end
if Organization.where(slug: 'fair_denmark').empty?
  o = Organization.create(name: "FAIR Denmark", slug: 'fair_denmark', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "https://www.fairdanmark.dk/en/")
  o.locations << Location.where(slug: 'denmark').limit(1)[0]
  o.locations << Location.where(slug: 'norway').limit(1)[0]
  l = Location.create(name: "Copenhagen, Denmark", slug: 'copenhagen_denmark', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (55.6760968, 12.5683372) ] WHERE slug = 'copenhagen_denmark'")
  o.locations << l
end
if Organization.where(slug: 'fhi_').empty?
  o = Organization.create(name: "FHI 360", slug: 'fhi_', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.fhi360.org/")
  o.sectors << Sector.where(slug: 'civil_society').limit(1)[0]
  o.sectors << Sector.where(slug: 'communication').limit(1)[0]
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'emergency_response').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'media').limit(1)[0]
  o.sectors << Sector.where(slug: 'media').limit(1)[0]
  o.sectors << Sector.where(slug: 'nutrition').limit(1)[0]
  o.sectors << Sector.where(slug: 'research').limit(1)[0]
  o.sectors << Sector.where(slug: 'youth').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'equatorial_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'jamaica').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Durham, NC", slug: 'durham_nc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (35.9940329, -78.898619) ] WHERE slug = 'durham_nc'")
  o.locations << l
end
if Organization.where(slug: 'fio').empty?
  o = Organization.create(name: "Fio", slug: 'fio', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.fio.com")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  l = Location.create(name: "Toronto, ON, Canada", slug: 'toronto_on_canada', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (43.653226, -79.3831843) ] WHERE slug = 'toronto_on_canada'")
  o.locations << l
end
if Organization.where(slug: 'forum_one').empty?
  o = Organization.create(name: "Forum One", slug: 'forum_one', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://forumone.com/")
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'hunger').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
end
if Organization.where(slug: 'foundation_botnar').empty?
  o = Organization.create(name: "Foundation Botnar", slug: 'foundation_botnar', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "https://www.fondationbotnar.org/en")
  o.sectors << Sector.where(slug: 'youth').limit(1)[0]
  o.locations << Location.where(slug: 'israel').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'switzerland').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
end
if Organization.where(slug: 'girl_effect_mobile__springster').empty?
  o = Organization.create(name: "Girl Effect Mobile - Springster ", slug: 'girl_effect_mobile__springster', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "girleffect.org")
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'youth').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  l = Location.create(name: "London, UK", slug: 'london_uk', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (51.5073509, -0.1277583) ] WHERE slug = 'london_uk'")
  o.locations << l
end
if Organization.where(slug: 'giz').empty?
  o = Organization.create(name: "GIZ", slug: 'giz', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "https://www.giz.de/en/html/index.html")
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'algeria').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'belarus').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'bulgaria').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'caribbean').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'chile').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'costa_rica').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'germany').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'greece').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'macedonia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'malaysia').limit(1)[0]
  o.locations << Location.where(slug: 'maldives').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'mongolia').limit(1)[0]
  o.locations << Location.where(slug: 'montenegro').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'paraguay').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'russia').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'saudi_arabia').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_arab_emirates').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'uzbekistan').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
end
if Organization.where(slug: 'global_integrity').empty?
  o = Organization.create(name: "Global Integrity", slug: 'global_integrity', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.globalintegrity.org/")
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'algeria').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'argentina').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'australia').limit(1)[0]
  o.locations << Location.where(slug: 'austria').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'belarus').limit(1)[0]
  o.locations << Location.where(slug: 'belgium').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'bulgaria').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'canada').limit(1)[0]
  o.locations << Location.where(slug: 'cape_verde').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'chile').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'comoros').limit(1)[0]
  o.locations << Location.where(slug: 'costa_rica').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'croatia').limit(1)[0]
  o.locations << Location.where(slug: 'czech_republic').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'djibouti').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'equatorial_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'eritrea').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'fiji').limit(1)[0]
  o.locations << Location.where(slug: 'france').limit(1)[0]
  o.locations << Location.where(slug: 'gabon').limit(1)[0]
  o.locations << Location.where(slug: 'gambia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'germany').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guinea_bissau').limit(1)[0]
  o.locations << Location.where(slug: 'hungary').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'ireland').limit(1)[0]
  o.locations << Location.where(slug: 'israel').limit(1)[0]
  o.locations << Location.where(slug: 'italy').limit(1)[0]
  o.locations << Location.where(slug: 'japan').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'latvia').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'lithuania').limit(1)[0]
  o.locations << Location.where(slug: 'macedonia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'malaysia').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'mauritius').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'mongolia').limit(1)[0]
  o.locations << Location.where(slug: 'montenegro').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'papua_new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'paraguay').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'poland').limit(1)[0]
  o.locations << Location.where(slug: 'qatar').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'russia').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'sao_tome_and_principe').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'seychelles').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'slovakia').limit(1)[0]
  o.locations << Location.where(slug: 'slovenia').limit(1)[0]
  o.locations << Location.where(slug: 'solomon_islands').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_korea').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'spain').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'sweden').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'tonga').limit(1)[0]
  o.locations << Location.where(slug: 'trinidad_and_tobago').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_arab_emirates').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'uruguay').limit(1)[0]
  o.locations << Location.where(slug: 'vanuatu').limit(1)[0]
  o.locations << Location.where(slug: 'venezuela').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'good_business').empty?
  o = Organization.create(name: "Good Business", slug: 'good_business', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.good.business")
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  l = Location.create(name: "London, UK", slug: 'london_uk', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (51.5073509, -0.1277583) ] WHERE slug = 'london_uk'")
  o.locations << l
end
if Organization.where(slug: 'grameen_foundation').empty?
  o = Organization.create(name: "Grameen Foundation", slug: 'grameen_foundation', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.grameenfoundation.org/")
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'hack__climate').empty?
  o = Organization.create(name: "Hack 4 Climate", slug: 'hack__climate', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "http://cleantech21.org")
  o.locations << Location.where(slug: 'switzerland').limit(1)[0]
  l = Location.create(name: "Zurich, Switzerland", slug: 'zurich_switzerland', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (47.3768866, 8.541694) ] WHERE slug = 'zurich_switzerland'")
  o.locations << l
end
if Organization.where(slug: 'healthenabled').empty?
  o = Organization.create(name: "HealthEnabled", slug: 'healthenabled', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://healthenabled.org/")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Cape Town, South Africa", slug: 'cape_town_south_africa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (-33.9248685, 18.4240553) ] WHERE slug = 'cape_town_south_africa'")
  o.locations << l
end
if Organization.where(slug: 'human_network_international_hni').empty?
  o = Organization.create(name: "Human Network International (HNI)", slug: 'human_network_international_hni', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://hni.org/")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'humanitarian_open_street_map_tea').empty?
  o = Organization.create(name: "Humanitarian Open Street Map Team ", slug: 'humanitarian_open_street_map_tea', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "")
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'instedd').empty?
  o = Organization.create(name: "InSTEDD", slug: 'instedd', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://instedd.org/")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  l = Location.create(name: "Sunnyvale, CA, USA", slug: 'sunnyvale_ca_usa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (37.36883, -122.0363496) ] WHERE slug = 'sunnyvale_ca_usa'")
  o.locations << l
end
if Organization.where(slug: 'institute_of_development_studies').empty?
  o = Organization.create(name: "Institute of Development Studies (IDS)", slug: 'institute_of_development_studies', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.ids.ac.uk")
end
if Organization.where(slug: 'integrity_global').empty?
  o = Organization.create(name: "Integrity Global", slug: 'integrity_global', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.integrityglobal.com")
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'oman').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
end
if Organization.where(slug: 'intellisoft').empty?
  o = Organization.create(name: "IntelliSOFT", slug: 'intellisoft', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.intellisoftkenya.com")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  l = Location.create(name: "Nairobi, Kenya", slug: 'nairobi_kenya', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (-1.2920659, 36.8219462) ] WHERE slug = 'nairobi_kenya'")
  o.locations << l
end
if Organization.where(slug: 'international_foundation_for_ele').empty?
  o = Organization.create(name: "International Foundation for Electoral Systems (IFES)", slug: 'international_foundation_for_ele', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.ifes.org/")
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'algeria').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'antigua_and_barbuda').limit(1)[0]
  o.locations << Location.where(slug: 'argentina').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'aruba').limit(1)[0]
  o.locations << Location.where(slug: 'australia').limit(1)[0]
  o.locations << Location.where(slug: 'austria').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'barbados').limit(1)[0]
  o.locations << Location.where(slug: 'belarus').limit(1)[0]
  o.locations << Location.where(slug: 'belgium').limit(1)[0]
  o.locations << Location.where(slug: 'belize').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bermuda').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'british_virgin_islands').limit(1)[0]
  o.locations << Location.where(slug: 'bulgaria').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'canada').limit(1)[0]
  o.locations << Location.where(slug: 'cape_verde').limit(1)[0]
  o.locations << Location.where(slug: 'cayman_islands').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'chile').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'comoros').limit(1)[0]
  o.locations << Location.where(slug: 'costa_rica').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'croatia').limit(1)[0]
  o.locations << Location.where(slug: 'cuba').limit(1)[0]
  o.locations << Location.where(slug: 'cyprus').limit(1)[0]
  o.locations << Location.where(slug: 'czech_republic').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'denmark').limit(1)[0]
  o.locations << Location.where(slug: 'djibouti').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'equatorial_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'estonia').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'fiji').limit(1)[0]
  o.locations << Location.where(slug: 'finland').limit(1)[0]
  o.locations << Location.where(slug: 'france').limit(1)[0]
  o.locations << Location.where(slug: 'gabon').limit(1)[0]
  o.locations << Location.where(slug: 'gambia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'germany').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'greece').limit(1)[0]
  o.locations << Location.where(slug: 'grenada').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guinea_bissau').limit(1)[0]
  o.locations << Location.where(slug: 'guyana').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'hong_kong').limit(1)[0]
  o.locations << Location.where(slug: 'hungary').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iran').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'italy').limit(1)[0]
  o.locations << Location.where(slug: 'jamaica').limit(1)[0]
  o.locations << Location.where(slug: 'japan').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'latvia').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'lithuania').limit(1)[0]
  o.locations << Location.where(slug: 'macao').limit(1)[0]
  o.locations << Location.where(slug: 'macedonia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'malaysia').limit(1)[0]
  o.locations << Location.where(slug: 'maldives').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'malta').limit(1)[0]
  o.locations << Location.where(slug: 'marshall_islands').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'mauritius').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'micronesia').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'monaco').limit(1)[0]
  o.locations << Location.where(slug: 'mongolia').limit(1)[0]
  o.locations << Location.where(slug: 'montenegro').limit(1)[0]
  o.locations << Location.where(slug: 'montserrat').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'netherlands').limit(1)[0]
  o.locations << Location.where(slug: 'new_zealand').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'norfolk_island').limit(1)[0]
  o.locations << Location.where(slug: 'northern_mariana_islands').limit(1)[0]
  o.locations << Location.where(slug: 'norway').limit(1)[0]
  o.locations << Location.where(slug: 'oman').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'papua_new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'paraguay').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'poland').limit(1)[0]
  o.locations << Location.where(slug: 'portugal').limit(1)[0]
  o.locations << Location.where(slug: 'puerto_rico').limit(1)[0]
  o.locations << Location.where(slug: 'qatar').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'russia').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'saint_kitts_and_nevis').limit(1)[0]
  o.locations << Location.where(slug: 'saint_lucia').limit(1)[0]
  o.locations << Location.where(slug: 'saint_vincent_and_the_grenadines').limit(1)[0]
  o.locations << Location.where(slug: 'samoa').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'seychelles').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'singapore').limit(1)[0]
  o.locations << Location.where(slug: 'slovakia').limit(1)[0]
  o.locations << Location.where(slug: 'slovenia').limit(1)[0]
  o.locations << Location.where(slug: 'solomon_islands').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'spain').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'suriname').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'sweden').limit(1)[0]
  o.locations << Location.where(slug: 'switzerland').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'taiwan').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'tonga').limit(1)[0]
  o.locations << Location.where(slug: 'trinidad_and_tobago').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'turkmenistan').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_arab_emirates').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'uruguay').limit(1)[0]
  o.locations << Location.where(slug: 'us_virgin_islands').limit(1)[0]
  o.locations << Location.where(slug: 'uzbekistan').limit(1)[0]
  o.locations << Location.where(slug: 'venezuela').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Arlington, VA", slug: 'arlington_va', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.8816208, -77.0909809) ] WHERE slug = 'arlington_va'")
  o.locations << l
end
if Organization.where(slug: 'international_initiative_for_imp').empty?
  o = Organization.create(name: "International Initiative for Impact Evaluation (3ie)", slug: 'international_initiative_for_imp', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "http://3ieimpact.org/")
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
end
if Organization.where(slug: 'international_rescue_committee_i').empty?
  o = Organization.create(name: "International Rescue Committee (IRC)", slug: 'international_rescue_committee_i', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.rescue.org/")
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'germany').limit(1)[0]
  o.locations << Location.where(slug: 'greece').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'italy').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
end
if Organization.where(slug: 'internews').empty?
  o = Organization.create(name: "Internews", slug: 'internews', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.internews.org/")
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'argentina').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'fiji').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'macedonia').limit(1)[0]
  o.locations << Location.where(slug: 'malaysia').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'montenegro').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'papua_new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'paraguay').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'puerto_rico').limit(1)[0]
  o.locations << Location.where(slug: 'samoa').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'suriname').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'vanuatu').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "California, USA", slug: 'california_usa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (36.778261, -119.4179324) ] WHERE slug = 'california_usa'")
  o.locations << l
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
  l = Location.create(name: "London, UK", slug: 'london_uk', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (51.5073509, -0.1277583) ] WHERE slug = 'london_uk'")
  o.locations << l
  l = Location.create(name: "Paris, France", slug: 'paris_france', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (48.856614, 2.3522219) ] WHERE slug = 'paris_france'")
  o.locations << l
end
if Organization.where(slug: 'intrahealth_international').empty?
  o = Organization.create(name: "IntraHealth International", slug: 'intrahealth_international', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.intrahealth.org/")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
end
if Organization.where(slug: 'irex').empty?
  o = Organization.create(name: "IREX", slug: 'irex', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.irex.org/")
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'algeria').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'argentina').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bahrain').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'belarus').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'bulgaria').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cabo_verde').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'chile').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'comoros').limit(1)[0]
  o.locations << Location.where(slug: 'costa_rica').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'croatia').limit(1)[0]
  o.locations << Location.where(slug: 'czech_republic').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'djibouti').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'equatorial_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'eritrea').limit(1)[0]
  o.locations << Location.where(slug: 'estonia').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'gabon').limit(1)[0]
  o.locations << Location.where(slug: 'gambia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guinea_bissau').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'hungary').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'israel').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'latvia').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'lithuania').limit(1)[0]
  o.locations << Location.where(slug: 'macedonia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'malaysia').limit(1)[0]
  o.locations << Location.where(slug: 'maldives').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'mauritius').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'mongolia').limit(1)[0]
  o.locations << Location.where(slug: 'montenegro').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'oman').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'papua_new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'paraguay').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'poland').limit(1)[0]
  o.locations << Location.where(slug: 'qatar').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'russia').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'sao_tome_and_principe').limit(1)[0]
  o.locations << Location.where(slug: 'saudi_arabia').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'seychelles').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'singapore').limit(1)[0]
  o.locations << Location.where(slug: 'slovakia').limit(1)[0]
  o.locations << Location.where(slug: 'slovenia').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'trinidad_and_tobago').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'turkmenistan').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_arab_emirates').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'uruguay').limit(1)[0]
  o.locations << Location.where(slug: 'uzbekistan').limit(1)[0]
  o.locations << Location.where(slug: 'venezuela').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'ist_uganda').empty?
  o = Organization.create(name: "IST Uganda", slug: 'ist_uganda', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "")
end
if Organization.where(slug: 'itech_mission_private_limited_it').empty?
  o = Organization.create(name: "iTech Mission Private Limited (iTM)", slug: 'itech_mission_private_limited_it', when_endorsed: DateTime.new(2015, 1, 1), is_endorser: true, website: "http://www.itechmission.org/ ")
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  l = Location.create(name: "New Delhi, India", slug: 'new_delhi_india', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (28.6139391, 77.2090212) ] WHERE slug = 'new_delhi_india'")
  o.locations << l
end
if Organization.where(slug: 'jhpiego').empty?
  o = Organization.create(name: "Jhpiego", slug: 'jhpiego', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.jhpiego.org/")
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Baltimore, MD", slug: 'baltimore_md', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (39.2903848, -76.6121893) ] WHERE slug = 'baltimore_md'")
  o.locations << l
end
if Organization.where(slug: 'john_snow_inc_jsi').empty?
  o = Organization.create(name: "John Snow, Inc. (JSI)", slug: 'john_snow_inc_jsi', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.jsi.com/")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'congo').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'djibouti').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'eritrea').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'gambia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guinea_bissau').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'russia').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'trinidad_and_tobago').limit(1)[0]
  o.locations << Location.where(slug: 'turkmenistan').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'uzbekistan').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "HQ: Boston, MA", slug: 'hq_boston_ma', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (42.328326, -71.07022) ] WHERE slug = 'hq_boston_ma'")
  o.locations << l
end
if Organization.where(slug: 'kimetrica').empty?
  o = Organization.create(name: "Kimetrica", slug: 'kimetrica', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "http://kimetrica.com")
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'ngo').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'france').limit(1)[0]
  o.locations << Location.where(slug: 'gambia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'switzerland').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
end
if Organization.where(slug: 'kingship_digital_inc').empty?
  o = Organization.create(name: "Kingship Digital Inc. ", slug: 'kingship_digital_inc', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.kingshipdigital.com")
  o.sectors << Sector.where(slug: 'consulting').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'media').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Kampala, Uganda", slug: 'kampala_uganda', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (0.3475964, 32.5825197) ] WHERE slug = 'kampala_uganda'")
  o.locations << l
end
if Organization.where(slug: 'lingos').empty?
  o = Organization.create(name: "LINGOs", slug: 'lingos', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://lingos.org/")
end
if Organization.where(slug: 'logical_outcomes').empty?
  o = Organization.create(name: "Logical Outcomes", slug: 'logical_outcomes', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "http://www.logicaloutcomes.net/")
  l = Location.create(name: "Toronto, Canada", slug: 'toronto_canada', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (43.653226, -79.3831843) ] WHERE slug = 'toronto_canada'")
  o.locations << l
end
if Organization.where(slug: 'lutheran_world_relief').empty?
  o = Organization.create(name: "Lutheran World Relief", slug: 'lutheran_world_relief', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "programs.lwr.org")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'climate').limit(1)[0]
  o.sectors << Sector.where(slug: 'emergency_response').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Baltimore, MD", slug: 'baltimore_md', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (39.2903848, -76.6121893) ] WHERE slug = 'baltimore_md'")
  o.locations << l
end
if Organization.where(slug: 'main_level').empty?
  o = Organization.create(name: "Main Level", slug: 'main_level', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.mainlevel.de")
  o.sectors << Sector.where(slug: 'consulting').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'argentina').limit(1)[0]
  o.locations << Location.where(slug: 'austria').limit(1)[0]
  o.locations << Location.where(slug: 'belgium').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'germany').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'mongolia').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'russia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'switzerland').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'uruguay').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Eschborn, Germany", slug: 'eschborn_germany', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (50.1467469, 8.5614555) ] WHERE slug = 'eschborn_germany'")
  o.locations << l
end
if Organization.where(slug: 'makaia').empty?
  o = Organization.create(name: "Makaia", slug: 'makaia', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "http://makaia.org/en/home/")
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  l = Location.create(name: "Medellín, Colombia.", slug: 'medelln_colombia', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (6.244203, -75.5812119) ] WHERE slug = 'medelln_colombia'")
  o.locations << l
end
if Organization.where(slug: 'medic_mobile').empty?
  o = Organization.create(name: "Medic Mobile", slug: 'medic_mobile', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://medicmobile.org/")
  o.sectors << Sector.where(slug: 'emergency_response').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "San Francisco, CA, USA", slug: 'san_francisco_ca_usa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (37.7749295, -122.4194155) ] WHERE slug = 'san_francisco_ca_usa'")
  o.locations << l
end
if Organization.where(slug: 'mercy_corps').empty?
  o = Organization.create(name: "Mercy Corps", slug: 'mercy_corps', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.mercycorps.org")
  o.sectors << Sector.where(slug: 'emergency_response').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'greece').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mongolia').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Portland, OR, USA", slug: 'portland_or_usa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (45.5122308, -122.6587185) ] WHERE slug = 'portland_or_usa'")
  o.locations << l
end
if Organization.where(slug: 'moonshot_global_consulting').empty?
  o = Organization.create(name: "Moonshot Global Consulting", slug: 'moonshot_global_consulting', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "http://moonshotglobal.com/")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'mpower_social_enterprises_ltd').empty?
  o = Organization.create(name: "mPower Social Enterprises Ltd.", slug: 'mpower_social_enterprises_ltd', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.mpower-social.com/")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Dhaka, Bangladesh", slug: 'dhaka_bangladesh', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (23.810332, 90.4125181) ] WHERE slug = 'dhaka_bangladesh'")
  o.locations << l
end
if Organization.where(slug: 'mpowering_frontline_health_worke').empty?
  o = Organization.create(name: "mPowering Frontline Health Workers", slug: 'mpowering_frontline_health_worke', when_endorsed: DateTime.new(2015, 1, 1), is_endorser: true, website: "http://mpoweringhealth.org/")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'nafundi').empty?
  o = Organization.create(name: "Nafundi", slug: 'nafundi', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://nafundi.com/")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  l = Location.create(name: "San Diego, CA, USA", slug: 'san_diego_ca_usa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (32.715738, -117.1610838) ] WHERE slug = 'san_diego_ca_usa'")
  o.locations << l
end
if Organization.where(slug: 'national_democratic_institute_nd').empty?
  o = Organization.create(name: "National Democratic Institute (NDI)", slug: 'national_democratic_institute_nd', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.ndi.org/")
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'belarus').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'bulgaria').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'croatia').limit(1)[0]
  o.locations << Location.where(slug: 'cuba').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'hong_kong').limit(1)[0]
  o.locations << Location.where(slug: 'hungary').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'macedonia').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'montenegro').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'north_korea').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'poland').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'russia').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'slovakia').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'venezuela').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'norwegian_peoples_aid').empty?
  o = Organization.create(name: "Norwegian People''s Aid", slug: 'norwegian_peoples_aid', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "http://www.npaid.org")
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'cuba').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Stockholm, Sweden", slug: 'stockholm_sweden', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (59.3293235, 18.0685808) ] WHERE slug = 'stockholm_sweden'")
  o.locations << l
end
if Organization.where(slug: 'ona').empty?
  o = Organization.create(name: "Ona", slug: 'ona', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://ona.io/home/")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
end
if Organization.where(slug: 'open_data_kit').empty?
  o = Organization.create(name: "Open Data Kit", slug: 'open_data_kit', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://opendatakit.org/")
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
end
if Organization.where(slug: 'openhie').empty?
  o = Organization.create(name: "OpenHIE", slug: 'openhie', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://ohie.org/")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
end
if Organization.where(slug: 'openlmis').empty?
  o = Organization.create(name: "OpenLMIS", slug: 'openlmis', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "http://openlmis.org/")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
end
if Organization.where(slug: 'openmrs').empty?
  o = Organization.create(name: "OpenMRS", slug: 'openmrs', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://openmrs.org/")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'algeria').limit(1)[0]
  o.locations << Location.where(slug: 'argentina').limit(1)[0]
  o.locations << Location.where(slug: 'australia').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'canada').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'france').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'germany').limit(1)[0]
  o.locations << Location.where(slug: 'greece').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'north_korea').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'puerto_rico').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'spain').limit(1)[0]
  o.locations << Location.where(slug: 'suriname').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  l = Location.create(name: "Carmel, IN, USA", slug: 'carmel_in_usa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (39.978371, -86.1180435) ] WHERE slug = 'carmel_in_usa'")
  o.locations << l
end
if Organization.where(slug: 'openwise').empty?
  o = Organization.create(name: "OpenWise", slug: 'openwise', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.openwise.co/")
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'oxfam').empty?
  o = Organization.create(name: "Oxfam", slug: 'oxfam', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "https://www.oxfam.org/ ")
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'ngo').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'algeria').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'australia').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'barbados').limit(1)[0]
  o.locations << Location.where(slug: 'belgium').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'canada').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'cuba').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'denmark').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'fiji').limit(1)[0]
  o.locations << Location.where(slug: 'france').limit(1)[0]
  o.locations << Location.where(slug: 'gambia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'germany').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'greece').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guinea_bissau').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'ireland').limit(1)[0]
  o.locations << Location.where(slug: 'italy').limit(1)[0]
  o.locations << Location.where(slug: 'japan').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'malaysia').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'netherlands').limit(1)[0]
  o.locations << Location.where(slug: 'new_zealand').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'north_korea').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'papua_new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'paraguay').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'russia').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'solomon_islands').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'spain').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'vanuatu').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'western_sahara').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Boston, MA, USA", slug: 'boston_ma_usa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (42.3600825, -71.0588801) ] WHERE slug = 'boston_ma_usa'")
  o.locations << l
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'palladium').empty?
  o = Organization.create(name: "Palladium", slug: 'palladium', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://thepalladiumgroup.com/")
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'logistics').limit(1)[0]
  o.sectors << Sector.where(slug: 'workforce').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'andorra').limit(1)[0]
  o.locations << Location.where(slug: 'anguilla').limit(1)[0]
  o.locations << Location.where(slug: 'argentina').limit(1)[0]
  o.locations << Location.where(slug: 'australia').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'canada').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'congo').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'fiji').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guyana').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'jamaica').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'macedonia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'nauru').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'netherlands').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'papua_new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'qatar').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'saudi_arabia').limit(1)[0]
  o.locations << Location.where(slug: 'singapore').limit(1)[0]
  o.locations << Location.where(slug: 'solomon_islands').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'spain').limit(1)[0]
  o.locations << Location.where(slug: 'sweden').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_arab_emirates').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'vanuatu').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "London, UK", slug: 'london_uk', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (51.5073509, -0.1277583) ] WHERE slug = 'london_uk'")
  o.locations << l
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
  l = Location.create(name: "Brisbane, Austrailia", slug: 'brisbane_austrailia', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (-27.4697707, 153.0251235) ] WHERE slug = 'brisbane_austrailia'")
  o.locations << l
  l = Location.create(name: "Dubai, United Arab Emirates", slug: 'dubai_united_arab_emirates', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (25.2048493, 55.2707828) ] WHERE slug = 'dubai_united_arab_emirates'")
  o.locations << l
  l = Location.create(name: "Abuja, Nigeria", slug: 'abuja_nigeria', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (9.0764785, 7.398574) ] WHERE slug = 'abuja_nigeria'")
  o.locations << l
  l = Location.create(name: "NY, NY", slug: 'ny_ny', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (40.7127753, -74.0059728) ] WHERE slug = 'ny_ny'")
  o.locations << l
  l = Location.create(name: "Canberra, Austrailia", slug: 'canberra_austrailia', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (-35.2809368, 149.1300092) ] WHERE slug = 'canberra_austrailia'")
  o.locations << l
  l = Location.create(name: "Jakarta, Indonesia", slug: 'jakarta_indonesia', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (-6.180495, 106.8283415) ] WHERE slug = 'jakarta_indonesia'")
  o.locations << l
  l = Location.create(name: "Nairobi, Kenya", slug: 'nairobi_kenya', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (-1.2920659, 36.8219462) ] WHERE slug = 'nairobi_kenya'")
  o.locations << l
  l = Location.create(name: "Sydney, Austrailia", slug: 'sydney_austrailia', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (-33.8688197, 151.2092955) ] WHERE slug = 'sydney_austrailia'")
  o.locations << l
end
if Organization.where(slug: 'path').empty?
  o = Organization.create(name: "PATH", slug: 'path', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.path.org/")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
end
if Organization.where(slug: 'pathfinder_international').empty?
  o = Organization.create(name: "Pathfinder International", slug: 'pathfinder_international', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.pathfinder.org/")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Watertown, MA, USA", slug: 'watertown_ma_usa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (42.3709299, -71.1828321) ] WHERE slug = 'watertown_ma_usa'")
  o.locations << l
end
if Organization.where(slug: 'people_in_need').empty?
  o = Organization.create(name: "People in Need", slug: 'people_in_need', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.peopleinneed.cz")
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'czech_republic').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'mongolia').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Prague, Czech Republic", slug: 'prague_czech_republic', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (50.0755381, 14.4378005) ] WHERE slug = 'prague_czech_republic'")
  o.locations << l
end
if Organization.where(slug: 'plan_international').empty?
  o = Organization.create(name: "Plan International", slug: 'plan_international', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "http://plan-international.org")
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'youth').limit(1)[0]
  o.locations << Location.where(slug: 'australia').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'belgium').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'canada').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'denmark').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'finland').limit(1)[0]
  o.locations << Location.where(slug: 'france').limit(1)[0]
  o.locations << Location.where(slug: 'germany').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guinea_bissau').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'hong_kong').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'ireland').limit(1)[0]
  o.locations << Location.where(slug: 'italy').limit(1)[0]
  o.locations << Location.where(slug: 'japan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'korea').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'netherlands').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'norway').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'paraguay').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'spain').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sweden').limit(1)[0]
  o.locations << Location.where(slug: 'switzerland').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Dukes Court, UK", slug: 'dukes_court_uk', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (51.3206581, -0.554314) ] WHERE slug = 'dukes_court_uk'")
  o.locations << l
end
if Organization.where(slug: 'praekeltorg').empty?
  o = Organization.create(name: "Praekelt.org", slug: 'praekeltorg', when_endorsed: DateTime.new(2015, 1, 1), is_endorser: true, website: "http://www.praekelt.org/")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
end
if Organization.where(slug: 'reboot').empty?
  o = Organization.create(name: "Reboot", slug: 'reboot', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://reboot.org/")
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'canada').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'czech_republic').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'netherlands').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'south_korea').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "NYC, USA", slug: 'nyc_usa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (40.7127753, -74.0059728) ] WHERE slug = 'nyc_usa'")
  o.locations << l
end
if Organization.where(slug: 'relief_applications').empty?
  o = Organization.create(name: "Relief Applications", slug: 'relief_applications', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "http://reliefapplications.org")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'costa_rica').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'france').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'italy').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'spain').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  l = Location.create(name: "Madrid, Spain", slug: 'madrid_spain', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (40.4167754, -3.7037902) ] WHERE slug = 'madrid_spain'")
  o.locations << l
end
if Organization.where(slug: 'resolve_to_save_lives').empty?
  o = Organization.create(name: "Resolve to Save Lives", slug: 'resolve_to_save_lives', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "resolvetosavelives.org")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  l = Location.create(name: "NYC, USA", slug: 'nyc_usa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (40.7127753, -74.0059728) ] WHERE slug = 'nyc_usa'")
  o.locations << l
end
if Organization.where(slug: 'rti_international').empty?
  o = Organization.create(name: "RTI International", slug: 'rti_international', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.rti.org/")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'energy').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'food').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'justice').limit(1)[0]
  o.sectors << Sector.where(slug: 'workforce').limit(1)[0]
  o.locations << Location.where(slug: 'barbados').limit(1)[0]
  o.locations << Location.where(slug: 'belize').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'jamaica').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_korea').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'suriname').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_arab_emirates').limit(1)[0]
  o.locations << Location.where(slug: 'uruguay').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Research Triangle Park, NC, USA", slug: 'research_triangle_park_nc_usa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (35.8991678, -78.8636402) ] WHERE slug = 'research_triangle_park_nc_usa'")
  o.locations << l
end
if Organization.where(slug: 'search_for_common_ground').empty?
  o = Organization.create(name: "Search for Common Ground", slug: 'search_for_common_ground', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.sfcg.org")
  o.sectors << Sector.where(slug: 'conflict_resolution').limit(1)[0]
  o.sectors << Sector.where(slug: 'demobilization__reintegration').limit(1)[0]
  o.sectors << Sector.where(slug: 'democracy').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'disarmament').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'fair__responsible_media').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'media').limit(1)[0]
  o.sectors << Sector.where(slug: 'media').limit(1)[0]
  o.sectors << Sector.where(slug: 'natural_resource_conflicts').limit(1)[0]
  o.sectors << Sector.where(slug: 'peace').limit(1)[0]
  o.sectors << Sector.where(slug: 'religious_engagement').limit(1)[0]
  o.sectors << Sector.where(slug: 'security').limit(1)[0]
  o.sectors << Sector.where(slug: 'security').limit(1)[0]
  o.sectors << Sector.where(slug: 'violent_extremism').limit(1)[0]
  o.locations << Location.where(slug: 'belgium').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'east_timor').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'macedonia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
  l = Location.create(name: "Brussles, Belgium", slug: 'brussles_belgium', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (50.8503463, 4.3517211) ] WHERE slug = 'brussles_belgium'")
  o.locations << l
end
if Organization.where(slug: 'slashroots_foundation').empty?
  o = Organization.create(name: "SlashRoots Foundation", slug: 'slashroots_foundation', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.slashroots.org/#/")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.locations << Location.where(slug: 'caribbean').limit(1)[0]
  l = Location.create(name: "Kingston, Jamaica", slug: 'kingston_jamaica', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (18.0178743, -76.8099041) ] WHERE slug = 'kingston_jamaica'")
  o.locations << l
end
if Organization.where(slug: 'smart_resultancy').empty?
  o = Organization.create(name: "SMART Resultancy", slug: 'smart_resultancy', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.smartresultancy.nl/")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'netherlands').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
end
if Organization.where(slug: 'somali_disaster_resilience_insti').empty?
  o = Organization.create(name: "Somali Disaster Resilience Institute (SDRI)", slug: 'somali_disaster_resilience_insti', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.sdri.so/")
  o.sectors << Sector.where(slug: 'emergency_response').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  l = Location.create(name: "Mogadishu, Somalia", slug: 'mogadishu_somalia', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (2.0469343, 45.3181623) ] WHERE slug = 'mogadishu_somalia'")
  o.locations << l
end
if Organization.where(slug: 'souktel').empty?
  o = Organization.create(name: "Souktel", slug: 'souktel', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.souktel.org/")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'democracy').limit(1)[0]
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'emergency_response').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'saudi_arabia').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'suriname').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_arab_emirates').limit(1)[0]
  o.locations << Location.where(slug: 'vanuatu').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
  l = Location.create(name: "Ramallah, Palestine", slug: 'ramallah_palestine', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (31.9037641, 35.2034184) ] WHERE slug = 'ramallah_palestine'")
  o.locations << l
end
if Organization.where(slug: 'surveycto').empty?
  o = Organization.create(name: "SurveyCTO", slug: 'surveycto', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.surveycto.com/index.html")
  o.sectors << Sector.where(slug: 'data_collection').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
end
if Organization.where(slug: 'swedish_international_developmen').empty?
  o = Organization.create(name: "Swedish International Development Cooperation Agency (SIDA)", slug: 'swedish_international_developmen', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.sida.se/English/")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'climate').limit(1)[0]
  o.sectors << Sector.where(slug: 'conflict_resolution').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'sustainability').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'belarus').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'cuba').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'russia').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Stockholm, Sweden", slug: 'stockholm_sweden', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (59.3293235, 18.0685808) ] WHERE slug = 'stockholm_sweden'")
  o.locations << l
end
if Organization.where(slug: 'sweetsense_inc').empty?
  o = Organization.create(name: "SweetSense, Inc.", slug: 'sweetsense_inc', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "www.sweetsensors.com")
  o.sectors << Sector.where(slug: 'energy').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'water_and_sanitation').limit(1)[0]
  o.sectors << Sector.where(slug: 'water_and_sanitation').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
end
if Organization.where(slug: 'techchange').empty?
  o = Organization.create(name: "TechChange", slug: 'techchange', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.techchange.org/")
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'tecsalud').empty?
  o = Organization.create(name: "TecSalud", slug: 'tecsalud', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "https://www.tecsalud.io/")
  o.locations << Location.where(slug: 'belize').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
end
if Organization.where(slug: 'terre_des_hommes').empty?
  o = Organization.create(name: "Terre des Hommes", slug: 'terre_des_hommes', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.ieda-project.org ")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'equatorial_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'greece').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'hungary').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'switzerland').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  l = Location.create(name: "Lausanne, 15 Avenue Montchoisi Lausanne 1006, Switzerland", slug: 'lausanne__avenue_montchoisi_laus', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (46.5134439, 6.6338339) ] WHERE slug = 'lausanne__avenue_montchoisi_laus'")
  o.locations << l
end
if Organization.where(slug: 'tetra_tech').empty?
  o = Organization.create(name: "Tetra Tech", slug: 'tetra_tech', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.tetratech.com/")
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'energy').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'infrastructure').limit(1)[0]
  o.sectors << Sector.where(slug: 'resource_management').limit(1)[0]
  o.sectors << Sector.where(slug: 'water_and_sanitation').limit(1)[0]
  o.locations << Location.where(slug: 'australia').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'canada').limit(1)[0]
  o.locations << Location.where(slug: 'chile').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'france').limit(1)[0]
  o.locations << Location.where(slug: 'germany').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'korea').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'new_zealand').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'united_arab_emirates').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
end
if Organization.where(slug: 'the_swedish_program_for_ict_in_d').empty?
  o = Organization.create(name: "The Swedish Program for ICT in Developing Regions (SPIDER)", slug: 'the_swedish_program_for_ict_in_d', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://spidercenter.org/")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'transparency__accountability').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
end
if Organization.where(slug: 'thinkmd').empty?
  o = Organization.create(name: "ThinkMD", slug: 'thinkmd', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.thinkmd.org/")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  l = Location.create(name: "Burlington, VA, USA", slug: 'burlington_va_usa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (44.4758825, -73.212072) ] WHERE slug = 'burlington_va_usa'")
  o.locations << l
end
if Organization.where(slug: 'toladata').empty?
  o = Organization.create(name: "TolaData", slug: 'toladata', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "http://toladata.com/")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  l = Location.create(name: "Berlin, Germany", slug: 'berlin_germany', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (52.5200066, 13.404954) ] WHERE slug = 'berlin_germany'")
  o.locations << l
end
if Organization.where(slug: 'tropical_health_and_education_tr').empty?
  o = Organization.create(name: "Tropical Health and Education Trust (THET)", slug: 'tropical_health_and_education_tr', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.thet.org")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "London, UK", slug: 'london_uk', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (51.5073509, -0.1277583) ] WHERE slug = 'london_uk'")
  o.locations << l
end
if Organization.where(slug: 'uk_department_for_international').empty?
  o = Organization.create(name: "UK Department for International Development (DFID)", slug: 'uk_department_for_international', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "https://www.gov.uk/government/organisations/department-for-international-development")
end
if Organization.where(slug: 'un_climate_change_secretariat').empty?
  o = Organization.create(name: "UN Climate Change Secretariat", slug: 'un_climate_change_secretariat', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "unfccc.int")
  o.sectors << Sector.where(slug: 'climate').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
end
if Organization.where(slug: 'united_nations_childrens_fund_un').empty?
  o = Organization.create(name: "United Nations Children’s Fund (UNICEF)", slug: 'united_nations_childrens_fund_un', when_endorsed: DateTime.new(2015, 1, 1), is_endorser: true, website: "https://www.unicef.org/")
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'youth').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'algeria').limit(1)[0]
  o.locations << Location.where(slug: 'andorra').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'anguilla').limit(1)[0]
  o.locations << Location.where(slug: 'antigua_and_barbuda').limit(1)[0]
  o.locations << Location.where(slug: 'argentina').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'australia').limit(1)[0]
  o.locations << Location.where(slug: 'austria').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bahrain').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'barbados').limit(1)[0]
  o.locations << Location.where(slug: 'belarus').limit(1)[0]
  o.locations << Location.where(slug: 'belgium').limit(1)[0]
  o.locations << Location.where(slug: 'belize').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bhutan').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'british_virgin_islands').limit(1)[0]
  o.locations << Location.where(slug: 'bulgaria').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cabo_verde').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'canada').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'chile').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'comoros').limit(1)[0]
  o.locations << Location.where(slug: 'congo').limit(1)[0]
  o.locations << Location.where(slug: 'cook_islands').limit(1)[0]
  o.locations << Location.where(slug: 'costa_rica').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'croatia').limit(1)[0]
  o.locations << Location.where(slug: 'cuba').limit(1)[0]
  o.locations << Location.where(slug: 'czech_republic').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'denmark').limit(1)[0]
  o.locations << Location.where(slug: 'djibouti').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'equatorial_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'eritrea').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'fiji').limit(1)[0]
  o.locations << Location.where(slug: 'finland').limit(1)[0]
  o.locations << Location.where(slug: 'france').limit(1)[0]
  o.locations << Location.where(slug: 'gabon').limit(1)[0]
  o.locations << Location.where(slug: 'gambia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'germany').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'greece').limit(1)[0]
  o.locations << Location.where(slug: 'grenada').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guinea_bissau').limit(1)[0]
  o.locations << Location.where(slug: 'guyana').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'hong_kong').limit(1)[0]
  o.locations << Location.where(slug: 'hungary').limit(1)[0]
  o.locations << Location.where(slug: 'iceland').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iran').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'ireland').limit(1)[0]
  o.locations << Location.where(slug: 'israel').limit(1)[0]
  o.locations << Location.where(slug: 'italy').limit(1)[0]
  o.locations << Location.where(slug: 'jamaica').limit(1)[0]
  o.locations << Location.where(slug: 'japan').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kiribati').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'lithuania').limit(1)[0]
  o.locations << Location.where(slug: 'luxembourg').limit(1)[0]
  o.locations << Location.where(slug: 'macedonia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'malaysia').limit(1)[0]
  o.locations << Location.where(slug: 'maldives').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'marshall_islands').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'micronesia').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'mongolia').limit(1)[0]
  o.locations << Location.where(slug: 'montenegro').limit(1)[0]
  o.locations << Location.where(slug: 'montserrat').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nauru').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'netherlands').limit(1)[0]
  o.locations << Location.where(slug: 'new_zealand').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'niue').limit(1)[0]
  o.locations << Location.where(slug: 'norway').limit(1)[0]
  o.locations << Location.where(slug: 'oman').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palau').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'papua_new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'paraguay').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'poland').limit(1)[0]
  o.locations << Location.where(slug: 'portugal').limit(1)[0]
  o.locations << Location.where(slug: 'qatar').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'saint_kitts_and_nevis').limit(1)[0]
  o.locations << Location.where(slug: 'saint_lucia').limit(1)[0]
  o.locations << Location.where(slug: 'saint_vincent_and_the_grenadines').limit(1)[0]
  o.locations << Location.where(slug: 'samoa').limit(1)[0]
  o.locations << Location.where(slug: 'sao_tome_and_principe').limit(1)[0]
  o.locations << Location.where(slug: 'saudi_arabia').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'slovakia').limit(1)[0]
  o.locations << Location.where(slug: 'slovenia').limit(1)[0]
  o.locations << Location.where(slug: 'solomon_islands').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_korea').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'spain').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'suriname').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'sweden').limit(1)[0]
  o.locations << Location.where(slug: 'switzerland').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'tokelau').limit(1)[0]
  o.locations << Location.where(slug: 'tonga').limit(1)[0]
  o.locations << Location.where(slug: 'trinidad_and_tobago').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'turkmenistan').limit(1)[0]
  o.locations << Location.where(slug: 'turks_and_caicos_islands').limit(1)[0]
  o.locations << Location.where(slug: 'tuvalu').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_arab_emirates').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'uruguay').limit(1)[0]
  o.locations << Location.where(slug: 'uzbekistan').limit(1)[0]
  o.locations << Location.where(slug: 'vanuatu').limit(1)[0]
  o.locations << Location.where(slug: 'venezuela').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
end
if Organization.where(slug: 'united_nations_development_progr').empty?
  o = Organization.create(name: "United Nations Development Programme (UNDP)", slug: 'united_nations_development_progr', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.undp.org/en")
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'development_impact').limit(1)[0]
  o.sectors << Sector.where(slug: 'emergency_response').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
end
if Organization.where(slug: 'united_nations_foundation_unf').empty?
  o = Organization.create(name: "United Nations Foundation (UNF)", slug: 'united_nations_foundation_unf', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.unfoundation.org")
  o.sectors << Sector.where(slug: 'climate').limit(1)[0]
  o.sectors << Sector.where(slug: 'energy').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  l = Location.create(name: "DC", slug: 'dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (37.09024, -95.712891) ] WHERE slug = 'dc'")
  o.locations << l
end
if Organization.where(slug: 'united_nations_global_pulse').empty?
  o = Organization.create(name: "United Nations Global Pulse", slug: 'united_nations_global_pulse', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.unglobalpulse.org/")
  o.sectors << Sector.where(slug: 'big_data').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
end
if Organization.where(slug: 'united_nations_office_for_the_co').empty?
  o = Organization.create(name: "United Nations Office for the Coordination of Humanitarian Affairs (OCHA)", slug: 'united_nations_office_for_the_co', when_endorsed: DateTime.new(2015, 1, 1), is_endorser: true, website: "https://www.unocha.org/")
  o.sectors << Sector.where(slug: 'emergency_response').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'eritrea').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'iran').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'japan').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'north_korea').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'switzerland').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_arab_emirates').limit(1)[0]
  o.locations << Location.where(slug: 'venezuela').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  l = Location.create(name: "NYC", slug: 'nyc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (40.7127753, -74.0059728) ] WHERE slug = 'nyc'")
  o.locations << l
  l = Location.create(name: "Geneva, Switzerland", slug: 'geneva_switzerland', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (46.2043907, 6.1431577) ] WHERE slug = 'geneva_switzerland'")
  o.locations << l
  l = Location.create(name: "Bangkok, Thailand", slug: 'bangkok_thailand', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (13.7563309, 100.5017651) ] WHERE slug = 'bangkok_thailand'")
  o.locations << l
  l = Location.create(name: "Dhakar, Senegal", slug: 'dhakar_senegal', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (14.716677, -17.4676861) ] WHERE slug = 'dhakar_senegal'")
  o.locations << l
  l = Location.create(name: "Nairobi, Kenya", slug: 'nairobi_kenya', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (-1.2920659, 36.8219462) ] WHERE slug = 'nairobi_kenya'")
  o.locations << l
  l = Location.create(name: "Office of Pacific Islands (near New Zealand)", slug: 'office_of_pacific_islands_near_n', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (-41.282324, 174.774992) ] WHERE slug = 'office_of_pacific_islands_near_n'")
  o.locations << l
end
if Organization.where(slug: 'united_nations_population_fund_u').empty?
  o = Organization.create(name: "United Nations Population Fund (UNFPA)", slug: 'united_nations_population_fund_u', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.unfpa.org")
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'corporation_and_business_managem').limit(1)[0]
  o.sectors << Sector.where(slug: 'emergency_response').limit(1)[0]
  o.sectors << Sector.where(slug: 'female_genital_mutilation').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'midwifery').limit(1)[0]
  o.sectors << Sector.where(slug: 'supply_chain_solutions').limit(1)[0]
  o.sectors << Sector.where(slug: 'world_population').limit(1)[0]
  o.sectors << Sector.where(slug: 'youth').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'belgium').limit(1)[0]
  o.locations << Location.where(slug: 'belgium').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'comoros').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'fiji').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea_bissau').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'jamaica').limit(1)[0]
  o.locations << Location.where(slug: 'japan').limit(1)[0]
  o.locations << Location.where(slug: 'japan').limit(1)[0]
  o.locations << Location.where(slug: 'japan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'maldives').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'oman').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'papua_new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'switzerland').limit(1)[0]
  o.locations << Location.where(slug: 'switzerland').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  l = Location.create(name: "Denamrk", slug: 'denamrk', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (56.26392, 9.501785) ] WHERE slug = 'denamrk'")
  o.locations << l
  l = Location.create(name: "Denamrk", slug: 'denamrk', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (56.26392, 9.501785) ] WHERE slug = 'denamrk'")
  o.locations << l
end
if Organization.where(slug: 'united_states_agency_for_interna').empty?
  o = Organization.create(name: "United States Agency for International Development (USAID)", slug: 'united_states_agency_for_interna', when_endorsed: DateTime.new(2015, 1, 1), is_endorser: true, website: "https://www.usaid.gov/")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'climate').limit(1)[0]
  o.sectors << Sector.where(slug: 'democracy').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'water_and_sanitation').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'belarus').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'cuba').limit(1)[0]
  o.locations << Location.where(slug: 'cyprus').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'djibouti').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guyana').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'jamaica').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'macedonia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'maldives').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'mongolia').limit(1)[0]
  o.locations << Location.where(slug: 'montenegro').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'paraguay').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'turkmenistan').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'uzbekistan').limit(1)[0]
  o.locations << Location.where(slug: 'venezuela').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
end
if Organization.where(slug: 'villagereach').empty?
  o = Organization.create(name: "VillageReach", slug: 'villagereach', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.villagereach.org/")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Seattle, WA, USA", slug: 'seattle_wa_usa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (47.6062095, -122.3320708) ] WHERE slug = 'seattle_wa_usa'")
  o.locations << l
end
if Organization.where(slug: 'vitalwave').empty?
  o = Organization.create(name: "VitalWave", slug: 'vitalwave', when_endorsed: DateTime.new(2017, 1, 1), is_endorser: true, website: "www.vitalwave.com")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'energy').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'mongolia').limit(1)[0]
  o.locations << Location.where(slug: 'montenegro').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'portugal').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  l = Location.create(name: "Paolo Alto, CA, USA", slug: 'paolo_alto_ca_usa', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (37.4418834, -122.1430195) ] WHERE slug = 'paolo_alto_ca_usa'")
  o.locations << l
end
if Organization.where(slug: 'voto_mobile').empty?
  o = Organization.create(name: "VOTO Mobile", slug: 'voto_mobile', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "https://www.votomobile.org/")
  o.sectors << Sector.where(slug: 'digital_development').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  o.sectors << Sector.where(slug: 'digitaldatatech').limit(1)[0]
  l = Location.create(name: "Current Offices:", slug: 'current_offices', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (36.8506952, -95.6356657) ] WHERE slug = 'current_offices'")
  o.locations << l
  l = Location.create(name: "Canada, US, UK, Senegal, Mali, Burkina Faso, Ghana, Niger, Nigeria, Ethiopia, Kenya, Uganda, Rawanda, DRC, Tanzania, Zambia, Malwai, Mozambique, Zimbabwe, Botswana, South Africa, Madagascar, Afghanistan, Pakistan, Nepal, India, Cambodia, Indonesia,", slug: 'canada_us_uk_senegal_mali_burkin', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (56.130366, -106.346771) ] WHERE slug = 'canada_us_uk_senegal_mali_burkin'")
  o.locations << l
end
if Organization.where(slug: 'welthungerhilfe').empty?
  o = Organization.create(name: "Welthungerhilfe", slug: 'welthungerhilfe', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "www.welthungerhilfe.de")
  o.sectors << Sector.where(slug: 'advocacy').limit(1)[0]
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'nutrition').limit(1)[0]
  o.sectors << Sector.where(slug: 'water_and_sanitation').limit(1)[0]
  o.sectors << Sector.where(slug: 'water_and_sanitation').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'north_korea').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Germany (maybe)", slug: 'germany_maybe', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (51.165691, 10.451526) ] WHERE slug = 'germany_maybe'")
  o.locations << l
end
if Organization.where(slug: 'world_agroforestry_center_icraf').empty?
  o = Organization.create(name: "World Agroforestry Center (ICRAF)", slug: 'world_agroforestry_center_icraf', when_endorsed: DateTime.new(2018, 1, 1), is_endorser: true, website: "http://worldagroforestry.org/")
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'bhutan').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'costa_rica').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'maldives').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
end
if Organization.where(slug: 'world_bank').empty?
  o = Organization.create(name: "World Bank", slug: 'world_bank', when_endorsed: DateTime.new(2016, 1, 1), is_endorser: true, website: "http://www.worldbank.org/")
  o.sectors << Sector.where(slug: 'agriculture').limit(1)[0]
  o.sectors << Sector.where(slug: 'economicsfinance').limit(1)[0]
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'energy').limit(1)[0]
  o.sectors << Sector.where(slug: 'environment').limit(1)[0]
  o.sectors << Sector.where(slug: 'gender_and_minority_groups').limit(1)[0]
  o.sectors << Sector.where(slug: 'governance').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.sectors << Sector.where(slug: 'water_and_sanitation').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'algeria').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'antigua_and_barbuda').limit(1)[0]
  o.locations << Location.where(slug: 'argentina').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'austria').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bahrain').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'belarus').limit(1)[0]
  o.locations << Location.where(slug: 'belgium').limit(1)[0]
  o.locations << Location.where(slug: 'belize').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bhutan').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'bulgaria').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cabo_verde').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'canada').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'chile').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'comoros').limit(1)[0]
  o.locations << Location.where(slug: 'costa_rica').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'croatia').limit(1)[0]
  o.locations << Location.where(slug: 'czech_republic').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'denmark').limit(1)[0]
  o.locations << Location.where(slug: 'djibouti').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'equatorial_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'eritrea').limit(1)[0]
  o.locations << Location.where(slug: 'estonia').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'fiji').limit(1)[0]
  o.locations << Location.where(slug: 'finland').limit(1)[0]
  o.locations << Location.where(slug: 'france').limit(1)[0]
  o.locations << Location.where(slug: 'gabon').limit(1)[0]
  o.locations << Location.where(slug: 'gambia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'germany').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'greece').limit(1)[0]
  o.locations << Location.where(slug: 'grenada').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guinea_bissau').limit(1)[0]
  o.locations << Location.where(slug: 'guyana').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'hungary').limit(1)[0]
  o.locations << Location.where(slug: 'iceland').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iran').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'israel').limit(1)[0]
  o.locations << Location.where(slug: 'italy').limit(1)[0]
  o.locations << Location.where(slug: 'jamaica').limit(1)[0]
  o.locations << Location.where(slug: 'japan').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kiribati').limit(1)[0]
  o.locations << Location.where(slug: 'korea').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'latvia').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'lithuania').limit(1)[0]
  o.locations << Location.where(slug: 'luxembourg').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'malaysia').limit(1)[0]
  o.locations << Location.where(slug: 'maldives').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'marshall_islands').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'mauritius').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'micronesia').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'mongolia').limit(1)[0]
  o.locations << Location.where(slug: 'montenegro').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nauru').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'netherlands').limit(1)[0]
  o.locations << Location.where(slug: 'new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'norway').limit(1)[0]
  o.locations << Location.where(slug: 'oman').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palau').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'papua_new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'paraguay').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'poland').limit(1)[0]
  o.locations << Location.where(slug: 'portugal').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'russia').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'saint_kitts_and_nevis').limit(1)[0]
  o.locations << Location.where(slug: 'saint_lucia').limit(1)[0]
  o.locations << Location.where(slug: 'saint_vincent_and_the_grenadines').limit(1)[0]
  o.locations << Location.where(slug: 'samoa').limit(1)[0]
  o.locations << Location.where(slug: 'sao_tome_and_principe').limit(1)[0]
  o.locations << Location.where(slug: 'saudi_arabia').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'seychelles').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'singapore').limit(1)[0]
  o.locations << Location.where(slug: 'slovakia').limit(1)[0]
  o.locations << Location.where(slug: 'slovenia').limit(1)[0]
  o.locations << Location.where(slug: 'solomon_islands').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'spain').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'suriname').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'sweden').limit(1)[0]
  o.locations << Location.where(slug: 'switzerland').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'tonga').limit(1)[0]
  o.locations << Location.where(slug: 'trinidad_and_tobago').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'turkmenistan').limit(1)[0]
  o.locations << Location.where(slug: 'tuvalu').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_arab_emirates').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'uruguay').limit(1)[0]
  o.locations << Location.where(slug: 'uzbekistan').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'world_food_programme_wfp').empty?
  o = Organization.create(name: "World Food Programme (WFP)", slug: 'world_food_programme_wfp', when_endorsed: DateTime.new(2015, 1, 1), is_endorser: true, website: "http://www1.wfp.org/")
  o.sectors << Sector.where(slug: 'emergency_response').limit(1)[0]
  o.sectors << Sector.where(slug: 'food').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'algeria').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bhutan').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'congo').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'cuba').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'djibouti').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'gambia').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guinea_bissau').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iran').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palestine').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'sao_tome_and_principe').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Rome, Italy", slug: 'rome_italy', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (41.9027835, 12.4963655) ] WHERE slug = 'rome_italy'")
  o.locations << l
  l = Location.create(name: "Washington, DC", slug: 'washington_dc', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (38.9071923, -77.0368707) ] WHERE slug = 'washington_dc'")
  o.locations << l
end
if Organization.where(slug: 'world_health_organization_who').empty?
  o = Organization.create(name: "World Health Organization (WHO)", slug: 'world_health_organization_who', when_endorsed: DateTime.new(2015, 1, 1), is_endorser: true, website: "http://www.who.int/en/")
  o.sectors << Sector.where(slug: 'health').limit(1)[0]
  o.locations << Location.where(slug: 'afghanistan').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'algeria').limit(1)[0]
  o.locations << Location.where(slug: 'andorra').limit(1)[0]
  o.locations << Location.where(slug: 'angola').limit(1)[0]
  o.locations << Location.where(slug: 'antigua_and_barbuda').limit(1)[0]
  o.locations << Location.where(slug: 'argentina').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'australia').limit(1)[0]
  o.locations << Location.where(slug: 'austria').limit(1)[0]
  o.locations << Location.where(slug: 'azerbaijan').limit(1)[0]
  o.locations << Location.where(slug: 'bahamas').limit(1)[0]
  o.locations << Location.where(slug: 'bahrain').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'barbados').limit(1)[0]
  o.locations << Location.where(slug: 'belarus').limit(1)[0]
  o.locations << Location.where(slug: 'belgium').limit(1)[0]
  o.locations << Location.where(slug: 'belize').limit(1)[0]
  o.locations << Location.where(slug: 'benin').limit(1)[0]
  o.locations << Location.where(slug: 'bhutan').limit(1)[0]
  o.locations << Location.where(slug: 'bolivia').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'botswana').limit(1)[0]
  o.locations << Location.where(slug: 'brazil').limit(1)[0]
  o.locations << Location.where(slug: 'brunei').limit(1)[0]
  o.locations << Location.where(slug: 'bulgaria').limit(1)[0]
  o.locations << Location.where(slug: 'burkina_faso').limit(1)[0]
  o.locations << Location.where(slug: 'burundi').limit(1)[0]
  o.locations << Location.where(slug: 'cabo_verde').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'cameroon').limit(1)[0]
  o.locations << Location.where(slug: 'canada').limit(1)[0]
  o.locations << Location.where(slug: 'central_african_republic').limit(1)[0]
  o.locations << Location.where(slug: 'chad').limit(1)[0]
  o.locations << Location.where(slug: 'chile').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'colombia').limit(1)[0]
  o.locations << Location.where(slug: 'comoros').limit(1)[0]
  o.locations << Location.where(slug: 'congo').limit(1)[0]
  o.locations << Location.where(slug: 'cook_islands').limit(1)[0]
  o.locations << Location.where(slug: 'costa_rica').limit(1)[0]
  o.locations << Location.where(slug: 'cote_dlvoire').limit(1)[0]
  o.locations << Location.where(slug: 'croatia').limit(1)[0]
  o.locations << Location.where(slug: 'cuba').limit(1)[0]
  o.locations << Location.where(slug: 'cyprus').limit(1)[0]
  o.locations << Location.where(slug: 'czech_republic').limit(1)[0]
  o.locations << Location.where(slug: 'democratic_republic_of_congo').limit(1)[0]
  o.locations << Location.where(slug: 'denmark').limit(1)[0]
  o.locations << Location.where(slug: 'djibouti').limit(1)[0]
  o.locations << Location.where(slug: 'dominican_republic').limit(1)[0]
  o.locations << Location.where(slug: 'ecuador').limit(1)[0]
  o.locations << Location.where(slug: 'egypt').limit(1)[0]
  o.locations << Location.where(slug: 'el_salvador').limit(1)[0]
  o.locations << Location.where(slug: 'equatorial_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'eritrea').limit(1)[0]
  o.locations << Location.where(slug: 'estonia').limit(1)[0]
  o.locations << Location.where(slug: 'ethiopia').limit(1)[0]
  o.locations << Location.where(slug: 'fiji').limit(1)[0]
  o.locations << Location.where(slug: 'finland').limit(1)[0]
  o.locations << Location.where(slug: 'france').limit(1)[0]
  o.locations << Location.where(slug: 'gabon').limit(1)[0]
  o.locations << Location.where(slug: 'gambia').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'germany').limit(1)[0]
  o.locations << Location.where(slug: 'ghana').limit(1)[0]
  o.locations << Location.where(slug: 'greece').limit(1)[0]
  o.locations << Location.where(slug: 'grenada').limit(1)[0]
  o.locations << Location.where(slug: 'guatemala').limit(1)[0]
  o.locations << Location.where(slug: 'guinea').limit(1)[0]
  o.locations << Location.where(slug: 'guinea_bissau').limit(1)[0]
  o.locations << Location.where(slug: 'guyana').limit(1)[0]
  o.locations << Location.where(slug: 'haiti').limit(1)[0]
  o.locations << Location.where(slug: 'honduras').limit(1)[0]
  o.locations << Location.where(slug: 'hungary').limit(1)[0]
  o.locations << Location.where(slug: 'iceland').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iran').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'ireland').limit(1)[0]
  o.locations << Location.where(slug: 'israel').limit(1)[0]
  o.locations << Location.where(slug: 'italy').limit(1)[0]
  o.locations << Location.where(slug: 'jamaica').limit(1)[0]
  o.locations << Location.where(slug: 'japan').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kazakhstan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kiribati').limit(1)[0]
  o.locations << Location.where(slug: 'kyrgystan').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'latvia').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'lesotho').limit(1)[0]
  o.locations << Location.where(slug: 'liberia').limit(1)[0]
  o.locations << Location.where(slug: 'libya').limit(1)[0]
  o.locations << Location.where(slug: 'lithuania').limit(1)[0]
  o.locations << Location.where(slug: 'luxembourg').limit(1)[0]
  o.locations << Location.where(slug: 'macedonia').limit(1)[0]
  o.locations << Location.where(slug: 'madagascar').limit(1)[0]
  o.locations << Location.where(slug: 'malawi').limit(1)[0]
  o.locations << Location.where(slug: 'malaysia').limit(1)[0]
  o.locations << Location.where(slug: 'maldives').limit(1)[0]
  o.locations << Location.where(slug: 'mali').limit(1)[0]
  o.locations << Location.where(slug: 'malta').limit(1)[0]
  o.locations << Location.where(slug: 'marshall_islands').limit(1)[0]
  o.locations << Location.where(slug: 'mauritania').limit(1)[0]
  o.locations << Location.where(slug: 'mauritius').limit(1)[0]
  o.locations << Location.where(slug: 'mexico').limit(1)[0]
  o.locations << Location.where(slug: 'micronesia').limit(1)[0]
  o.locations << Location.where(slug: 'moldova').limit(1)[0]
  o.locations << Location.where(slug: 'monaco').limit(1)[0]
  o.locations << Location.where(slug: 'mongolia').limit(1)[0]
  o.locations << Location.where(slug: 'montenegro').limit(1)[0]
  o.locations << Location.where(slug: 'morocco').limit(1)[0]
  o.locations << Location.where(slug: 'mozambique').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'namibia').limit(1)[0]
  o.locations << Location.where(slug: 'nauru').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'netherlands').limit(1)[0]
  o.locations << Location.where(slug: 'new_zealand').limit(1)[0]
  o.locations << Location.where(slug: 'nicaragua').limit(1)[0]
  o.locations << Location.where(slug: 'niger').limit(1)[0]
  o.locations << Location.where(slug: 'nigeria').limit(1)[0]
  o.locations << Location.where(slug: 'niue').limit(1)[0]
  o.locations << Location.where(slug: 'norway').limit(1)[0]
  o.locations << Location.where(slug: 'oman').limit(1)[0]
  o.locations << Location.where(slug: 'pakistan').limit(1)[0]
  o.locations << Location.where(slug: 'palau').limit(1)[0]
  o.locations << Location.where(slug: 'panama').limit(1)[0]
  o.locations << Location.where(slug: 'papua_new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'paraguay').limit(1)[0]
  o.locations << Location.where(slug: 'peru').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'poland').limit(1)[0]
  o.locations << Location.where(slug: 'portugal').limit(1)[0]
  o.locations << Location.where(slug: 'qatar').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'russia').limit(1)[0]
  o.locations << Location.where(slug: 'rwanda').limit(1)[0]
  o.locations << Location.where(slug: 'saint_kitts_and_nevis').limit(1)[0]
  o.locations << Location.where(slug: 'saint_lucia').limit(1)[0]
  o.locations << Location.where(slug: 'saint_vincent_and_the_grenadines').limit(1)[0]
  o.locations << Location.where(slug: 'samoa').limit(1)[0]
  o.locations << Location.where(slug: 'san_marino').limit(1)[0]
  o.locations << Location.where(slug: 'sao_tome_and_principe').limit(1)[0]
  o.locations << Location.where(slug: 'saudi_arabia').limit(1)[0]
  o.locations << Location.where(slug: 'senegal').limit(1)[0]
  o.locations << Location.where(slug: 'serbia').limit(1)[0]
  o.locations << Location.where(slug: 'seychelles').limit(1)[0]
  o.locations << Location.where(slug: 'sierra_leone').limit(1)[0]
  o.locations << Location.where(slug: 'singapore').limit(1)[0]
  o.locations << Location.where(slug: 'slovakia').limit(1)[0]
  o.locations << Location.where(slug: 'slovenia').limit(1)[0]
  o.locations << Location.where(slug: 'solomon_islands').limit(1)[0]
  o.locations << Location.where(slug: 'somalia').limit(1)[0]
  o.locations << Location.where(slug: 'south_africa').limit(1)[0]
  o.locations << Location.where(slug: 'south_korea').limit(1)[0]
  o.locations << Location.where(slug: 'south_sudan').limit(1)[0]
  o.locations << Location.where(slug: 'spain').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'sudan').limit(1)[0]
  o.locations << Location.where(slug: 'suriname').limit(1)[0]
  o.locations << Location.where(slug: 'swaziland').limit(1)[0]
  o.locations << Location.where(slug: 'sweden').limit(1)[0]
  o.locations << Location.where(slug: 'switzerland').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'tajikistan').limit(1)[0]
  o.locations << Location.where(slug: 'tanzania').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'togo').limit(1)[0]
  o.locations << Location.where(slug: 'tonga').limit(1)[0]
  o.locations << Location.where(slug: 'trinidad_and_tobago').limit(1)[0]
  o.locations << Location.where(slug: 'tunisia').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'turkmenistan').limit(1)[0]
  o.locations << Location.where(slug: 'tuvalu').limit(1)[0]
  o.locations << Location.where(slug: 'uganda').limit(1)[0]
  o.locations << Location.where(slug: 'ukraine').limit(1)[0]
  o.locations << Location.where(slug: 'united_arab_emirates').limit(1)[0]
  o.locations << Location.where(slug: 'united_kingdom').limit(1)[0]
  o.locations << Location.where(slug: 'united_states').limit(1)[0]
  o.locations << Location.where(slug: 'uruguay').limit(1)[0]
  o.locations << Location.where(slug: 'uzbekistan').limit(1)[0]
  o.locations << Location.where(slug: 'vanuatu').limit(1)[0]
  o.locations << Location.where(slug: 'venezuela').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
  o.locations << Location.where(slug: 'yemen').limit(1)[0]
  o.locations << Location.where(slug: 'zambia').limit(1)[0]
  o.locations << Location.where(slug: 'zimbabwe').limit(1)[0]
  l = Location.create(name: "Geneva", slug: 'geneva', :location_type => :point)
  connection.execute("UPDATE locations SET points = ARRAY[ POINT (46.2043907, 6.1431577) ] WHERE slug = 'geneva'")
  o.locations << l
end
if Organization.where(slug: 'world_vision_international').empty?
  o = Organization.create(name: "World Vision International", slug: 'world_vision_international', when_endorsed: DateTime.new(2015, 1, 1), is_endorser: true, website: "http://www.wvi.org/")
  o.sectors << Sector.where(slug: 'education').limit(1)[0]
  o.sectors << Sector.where(slug: 'emergency_response').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'humanitarian').limit(1)[0]
  o.sectors << Sector.where(slug: 'youth').limit(1)[0]
  o.locations << Location.where(slug: 'albania').limit(1)[0]
  o.locations << Location.where(slug: 'armenia').limit(1)[0]
  o.locations << Location.where(slug: 'bangladesh').limit(1)[0]
  o.locations << Location.where(slug: 'bosnia__herzegovina').limit(1)[0]
  o.locations << Location.where(slug: 'cambodia').limit(1)[0]
  o.locations << Location.where(slug: 'china').limit(1)[0]
  o.locations << Location.where(slug: 'gaza').limit(1)[0]
  o.locations << Location.where(slug: 'georgia').limit(1)[0]
  o.locations << Location.where(slug: 'india').limit(1)[0]
  o.locations << Location.where(slug: 'indonesia').limit(1)[0]
  o.locations << Location.where(slug: 'iraq').limit(1)[0]
  o.locations << Location.where(slug: 'jordan').limit(1)[0]
  o.locations << Location.where(slug: 'kenya').limit(1)[0]
  o.locations << Location.where(slug: 'kosovo').limit(1)[0]
  o.locations << Location.where(slug: 'laos').limit(1)[0]
  o.locations << Location.where(slug: 'lebanon').limit(1)[0]
  o.locations << Location.where(slug: 'mongolia').limit(1)[0]
  o.locations << Location.where(slug: 'myanmar').limit(1)[0]
  o.locations << Location.where(slug: 'nepal').limit(1)[0]
  o.locations << Location.where(slug: 'north_korea').limit(1)[0]
  o.locations << Location.where(slug: 'papua_new_guinea').limit(1)[0]
  o.locations << Location.where(slug: 'philippines').limit(1)[0]
  o.locations << Location.where(slug: 'romania').limit(1)[0]
  o.locations << Location.where(slug: 'solomon_islands').limit(1)[0]
  o.locations << Location.where(slug: 'sri_lanka').limit(1)[0]
  o.locations << Location.where(slug: 'syria').limit(1)[0]
  o.locations << Location.where(slug: 'thailand').limit(1)[0]
  o.locations << Location.where(slug: 'timor_leste').limit(1)[0]
  o.locations << Location.where(slug: 'turkey').limit(1)[0]
  o.locations << Location.where(slug: 'vanuatu').limit(1)[0]
  o.locations << Location.where(slug: 'vietnam').limit(1)[0]
end
f = File.join(Rails.root, 'db', 'contacts.rb')
if File.exists?(f)
  load f
end