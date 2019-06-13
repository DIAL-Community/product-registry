if Workflow.where(slug: 'client_case_management').empty?
    w = Workflow.create(name: "Client Case Management", category: "Customer Services", slug: "client_case_management", description: "Enrollment, tracking and monitoring of services provided to a beneficiary or household often across multiple service categories.", other_names: "Beneficiary Case Management")
    w.use_cases << UseCase.where(slug: 'remote_learning').limit(1)[0]
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'client_case_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'consent_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'content_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'data_collection').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'digital_registries').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'payments').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'registration').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'reporting_and_dashboards').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'security').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'shared_data_repositories').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'workflow_and_algorithm').limit(1)[0]
end
if Workflow.where(slug: 'client_communication').empty?
    w = Workflow.create(name: "Client Communication", category: "Marketing and Sales", slug: "client_communication", description: "Bulk or individual communication between businesses and their clients or between individuals using a variety of channels, such as a electronic mail, short messaging service, interactive voice response, or social media.", other_names: "Campaigning, Promotion, Marketing, Awareness raising")
    w.use_cases << UseCase.where(slug: 'market_linkage').limit(1)[0]
    w.use_cases << UseCase.where(slug: 'remote_learning').limit(1)[0]
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'client_case_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'data_collection').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'messaging').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'mobility_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'registration').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'scheduling').limit(1)[0]
end
if Workflow.where(slug: 'client_education').empty?
    w = Workflow.create(name: "Client Education", category: "Customer Services", slug: "client_education", description: "Creation and dissemination of educational content for training or to promote awareness of a topic.", other_names: "Learning")
    w.use_cases << UseCase.where(slug: 'remote_learning').limit(1)[0]
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'client_case_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'collaboration_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'content_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'digital_registries').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'elearning').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'payments').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'reporting_and_dashboards').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'security').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'shared_data_repositories').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'terminology').limit(1)[0]
end
if Workflow.where(slug: 'content_management').empty?
    w = Workflow.create(name: "Content Management", category: "Operations", slug: "content_management", description: "Create, organize, and secure digital content (text and multimedia) to make it easier to navigate and retrieve throughout an organization.", other_names: "Content digitization")
    w.use_cases << UseCase.where(slug: 'remote_learning').limit(1)[0]
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'content_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'reporting_and_dashboards').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'security').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'shared_data_repositories').limit(1)[0]
end
if Workflow.where(slug: 'data_analysis_and_business_intelligence').empty?
    w = Workflow.create(name: "Data Analysis and Business Intelligence", category: "Administration and Management", slug: "data_analysis_and_business_intelligence", description: "Defining aggregate functions across samples of data values, creating alerts around anomalous or statistically significant events or occurrences in the data.", other_names: "Data Mining")
    w.use_cases << UseCase.where(slug: 'market_linkage').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'analytics_and_business_intellige').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'artificial_intelligence').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'reporting_and_dashboards').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'security').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'shared_data_repositories').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'terminology').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'workflow_and_algorithm').limit(1)[0]
end
if Workflow.where(slug: 'data_collection_and_reporting').empty?
    w = Workflow.create(name: "Data Collection and Reporting", category: "Administration and Management", slug: "data_collection_and_reporting", description: "Defining, collecting, validating, normalizing and Aggregating structured data of all kinds (often to replace paper forms): text, numeric, geospatial or multi-media.", other_names: "Surveying, Surveillance")
    w.use_cases << UseCase.where(slug: 'market_linkage').limit(1)[0]
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'data_collection').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'digital_registries').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'geographic_information_services').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'messaging').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'mobility_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'registration').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'reporting_and_dashboards').limit(1)[0]
end
if Workflow.where(slug: 'decision_support').empty?
    w = Workflow.create(name: "Decision Support", category: "Customer Services", slug: "decision_support", description: "Applying generic aggregation or analytical algorithms to raw data, combining these results with domain-specific business knowledge, to produce strategic, actionable insights or alerts.", other_names: "Analytics")
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
end
if Workflow.where(slug: 'financial_services').empty?
    w = Workflow.create(name: "Financial Services", category: "Outbound Logistics", slug: "financial_services", description: "Integration between an organization, its beneficiaries, and the ability to automate banking service functions between the two.", other_names: "eCommerce, Payment platforms")
    w.use_cases << UseCase.where(slug: 'market_linkage').limit(1)[0]
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'emarketplace').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'messaging').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'payments').limit(1)[0]
end
if Workflow.where(slug: 'identification_and_registration').empty?
    w = Workflow.create(name: "Identification and Registration", category: "Outbound Logistics", slug: "identification_and_registration", description: "Uniquely identify and collect other pertinent information about people and pertinent business objects (inventory, locations, or events) for any particular business process.", other_names: "On boarding")
    w.use_cases << UseCase.where(slug: 'market_linkage').limit(1)[0]
    w.use_cases << UseCase.where(slug: 'remote_learning').limit(1)[0]
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'consent_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'digital_registries').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'geographic_information_services').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'mobility_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'registration').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'security').limit(1)[0]
end
if Workflow.where(slug: 'knowledge_management').empty?
    w = Workflow.create(name: "Knowledge Management", category: "Technology Development", slug: "knowledge_management", description: "Collect, sort, and archive organizational assets for ease retrieval and assimilation.", other_names: "Information Architecture")
    w.building_blocks << BuildingBlock.where(slug: 'content_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'elearning').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'security').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'shared_data_repositories').limit(1)[0]
end
if Workflow.where(slug: 'marketplace').empty?
    w = Workflow.create(name: "Marketplace", category: "Marketing and Sales", slug: "marketplace", description: "A discovery platform between buyers and sellers, allowing for easy transactions of goods and services.", other_names: "Trade, commerce")
    w.use_cases << UseCase.where(slug: 'market_linkage').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'digital_registries').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'messaging').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'payments').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'registration').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'security').limit(1)[0]
end
if Workflow.where(slug: 'problem_diagnosis').empty?
    w = Workflow.create(name: "Problem Diagnosis", category: "Customer Services", slug: "problem_diagnosis", description: "Build a model of hypothetical diagnoses, iteratively incorporating new data and eliminating invalid diagnoses.", other_names: "Troubleshooting")
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'artificial_intelligence').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'workflow_and_algorithm').limit(1)[0]
end
if Workflow.where(slug: 'procurement').empty?
    w = Workflow.create(name: "Procurement", category: "Procurement", slug: "procurement", description: "Management of business functions of procurement planning, purchasing, inventory control, traffic, receiving, incoming inspection and salvage operations.", other_names: "Inventory Management")
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'emarketplace').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'payments').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'workflow_and_algorithm').limit(1)[0]
end
if Workflow.where(slug: 'remote_monitoring').empty?
    w = Workflow.create(name: "Remote Monitoring", category: "Customer Services", slug: "remote_monitoring", description: "The automated collection of real-time (often time-series) data from a distributed sensor grid.", other_names: "Distributed Sensing")
    w.use_cases << UseCase.where(slug: 'market_linkage').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'reporting_and_dashboards').limit(1)[0]
end
if Workflow.where(slug: 'supply_chain_management').empty?
    w = Workflow.create(name: "Supply Chain Management", category: "Inbound Logistics", slug: "supply_chain_management", description: "Track, manage and optimize all aspects of a supply chain, including avoiding stockouts, minimizing wastage, and providing an audit trail.", other_names: "Logistics Management, Cold chain management")
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'geographic_information_services').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'messaging').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'mobility_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'payments').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'registration').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'scheduling').limit(1)[0]
end
if Workflow.where(slug: 'work_planning_and_coordination').empty?
    w = Workflow.create(name: "Work Planning and Coordination", category: "Human Resources Management", slug: "work_planning_and_coordination", description: "Orchestrate the coordination and timing of activities of teams and team members within an organization", other_names: "Project Management, Task Tracking")
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'scheduling').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'workflow_and_algorithm').limit(1)[0]
end
