if Workflow.where(slug: 'client_case_management').empty?
    w = Workflow.create(name: "Client Case Management", slug: "client_case_management", description: '{
        "name":"Client Case Management",
        "other_names": "Beneficiary case management",
        "short_desc": "Enrolment, tracking and monitoring of services provided to a beneficiary or household, often across multiple service categories.",
        "full_desc": "The client case management WorkFlow involves the registration or enrolment of a user and the longitudinal tracking of services for that user often across multiple service categories, multiple service providers, and multiple locations. Users may avail themselves of one or more services from the organization. Services may be delivered by one or more providers at different points in time. From initial client registration, all services booked, availed of, or cancelled, along with transactional history and status, often need longitudinal tracking to avoid confusion across the multiple service categories, multiple service providers, and multiple locations and schedules that the client may be associated with as they journey through different organizations. Common case management WorkFlow includes capturing client and demographic information, appointment and event scheduling, messaging and reminders, management and prioritization of tasks across multiple cases, and summarizing client case data for reporting. Case managers commonly employ one or more job aids, each facilitating a particular service, and potentially customized according to client attributes.",
        "sample_mappings": [
            {"name":"Agriculture: Market linkage","description":"Tracking of market transactions"},
            {"name":"Education: Remote learning","description":"Enrolment in training programmes and tracking progress over time. Track beneficiaries progress through course material"},
            {"name":"Health: Maternal and newborn health","description": "Tracking of antenatal attendance, birth outcome and immunizations"}
            ]
    }')
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
    w = Workflow.create(name: "Client Communication", slug: "client_communication", description: '{
        "name":"Client Communication",
        "other_names": "Campaigning, Promotion, Marketing, Awareness raising",
        "short_desc": "Bulk or individual communication between businesses and their clients or between individuals using a variety of channels, such as email, short messaging service, interactive voice response, or social media.",
        "full_desc": "All organizations need to communicate with their end-users to share information, influence behaviour changes or get feedback. Communication may be targeted to a certain user or certain profile of users or be untargeted (mass communications). It can also be one-way or two-way (interactive) communication. It can serve to send alerts and notifications in real time in case of emergencies, or can be based on specific conditions or time intervals.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":"Automated notification of harvest schedule, market prices for subscribed products, and weather/natural disaster updates"},
            {"name":"Education: Remote learning","description":"Reminders for assignment due dates, new course material availability, etc"},
            {"name":"Health: Maternal and newborn health","description":"Sending appointment reminders, receiving questions from mothers"}
        ]
    }')
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
    w = Workflow.create(name: "Client Education", slug: "client_education", description: '{
        "name":"Client Education",
        "other_names": "Learning",
        "short_desc": "Creation and dissemination of educational content for training or to promote awareness of a topic.",
        "full_desc": "Several organizations need to educate their users with knowledge targeted at developing specific skills or behavioural changes, or enhancing public awareness about a topic, service or programme. In most cases, they use a course or programme’s educative content, which is delivered inside or outside of a traditional classroom or educational institution. It could also include information and illustrative content to create awareness about specific concepts, services and facilities. It uses assessment tools to evaluate the achievement of learning objectives. Common examples of client education include the training of field workers supporting users in adopting new processes, introducing women to the importance of and facilities for hygiene management, family planning and institutional assistance for managing pregnancy, or for supporting formal education in educational institutes.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":"Enrolment in training programs to access market services to improve profitability"},
            {"name":"Education: Remote learning","description":"Creation and dissemination of all course materials"},
            {"name":"Health: Maternal and newborn health","description":"Information about facility-based deliveries, the importance of pre- and post-delivery care and scheduled vaccinations"}
        ]
    }')
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
    w = Workflow.create(name: "Content Management", slug: "content_management", description: '{
        "name":"Content Management",
        "other_names": "Content digitization",
        "short_desc": "Create, organize, publish and secure content (text and multimedia) to make it easier to navigate and retrieve throughout an organization.",
        "full_desc": "Most organizations need to create/access/populate content in different (digital) formats including text, images, video, audio, etc, stored in various locations and that have to be distributed securely from/to various entities. Content management WorkFlow therefore manages and organizes different types of multimedia content along with the mechanisms to access and operate on it as key assets of the organization. It also enforces policies for information security, privacy, storage, retention, optimization, transmission, quality, etc, and enables its indexing, searching, sorting, access control, compression, encryption, replication and anonymization.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":"Manage content customized to farmer needs based on language, geographical region, education-level, or other attributes"},
            {"name":"Education: Remote learning","description":"Providing relevant, timely content for literacy learners"},
            {"name":"Health: Maternal and newborn health", "description":"Store and retrieve educational and promotional content for use during field visits"}
        ]
    }')
    w.use_cases << UseCase.where(slug: 'remote_learning').limit(1)[0]
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'content_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'reporting_and_dashboards').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'security').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'shared_data_repositories').limit(1)[0]
end
if Workflow.where(slug: 'data_analysis_and_business_intelligence').empty?
    w = Workflow.create(name: "Data Analysis and Business Intelligence", slug: "data_analysis_and_business_intelligence", description: '{
        "name":"Data Analysis And Business Intelligence",
        "other_names": "Data mining, Dashboards and alerts",
        "short_desc": "Defining aggregate functions across samples of data values, creating alerts around anomalous or statistically significant events or occurrences in the data.",
        "full_desc": "Throughout any programme lifecycle of engagement with citizens, different departments/projects need to monitor and analyze the progress of certain activities to identify and promote best practices, course corrections and interventions as needed for continuous improvement in effectiveness, efficiency and sustainability of activities. Data analysis and business intelligence WorkFlow provides this functionality. Common data analysis and business intelligence activities include analysing samples from relevant groups of parametric values to derive statistical and combinatorial indicators, and then analysing the indicators to identify and flag abnormal events/ trends and relevant parties. They can subject the information to preset thresholds to determine whether escalation is required or not, and accordingly trigger notification/ alert mechanisms to proactively/reactively inform authorized users.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":"Assess trends in rural farm productivity based on crop, proximity to market and other factors, such as weather"},
            {"name":"Education: Remote learning","description":"Analyze effectiveness of learning programmes in resulting in the development of new skills or competencies"},
            {"name":"Health: Maternal and newborn health","description":"Evaluate the impact of successful completion of maternal and newborn health programme on maternal and newborn mortality reduction"}
        ]
    }')
    w.use_cases << UseCase.where(slug: 'market_linkage').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'analytics_and_business_intel').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'artificial_intelligence').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'reporting_and_dashboards').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'security').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'shared_data_repositories').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'terminology').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'workflow_and_algorithm').limit(1)[0]
end
if Workflow.where(slug: 'data_collection_and_reporting').empty?
    w = Workflow.create(name: "Data Collection and Reporting", slug: "data_collection_and_reporting", description: '{
        "name":"Data Collection And Reporting",
        "other_names": "Surveying, Surveillance",
        "short_desc": "Defining, collecting, validating, normalizing and aggregating structured data of all kinds (often to replace paper forms): text, numeric, geospatial or multimedia.",
        "full_desc": "This generic WorkFlow or business process concerns the collection and reporting of data that almost every organization needs in order to support decision-making and planning. It is also used to generate operational performance indicators for the service delivery process. For example, data collection activities can focus on the environment to help promote public health safety and hygiene; gather information such as sowing date, sowing area of crops, and livestock age, sex and vaccination records; and track health information such as malaria cases or disease outbreaks. Common data collection and reporting activities include the capture of different types of data, such as text, sensory and multimedia data; normalization of formats from various sources into standardized measurement units; data aggregation; grouping measurements of different parameters into sets for various applications; and presenting data in corresponding report formats.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":"Collect commodity price data from major marketplaces"},
            {"name":"Education: Remote learning","description":"Collect data on service use and results of visits"},
            {"name":"Health: Maternal and newborn health","description":"Record student performance and feedback on teaching"}
        ]
    }')
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
    w = Workflow.create(name: "Decision Support", slug: "decision_support", description: '{
        "name":"Decision Support",
        "other_names": "Analytics",
        "short_desc": "Applying generic aggregation or analytical algorithms to raw data, combining these results with domain-specific business knowledge, to produce strategic, actionable insights or alerts.",
        "full_desc": "This WorkFlow involves a process of analysing data and parameters to produce meaningful information or inferences (models), which help in decision-making (for humans). Decision support can be purely analytical or cognitive (eg deep learning). Examples of decision support include crop pest alert systems, clinical decision support systems, etc. Common decision support WorkFlow involves capturing raw data using collection tools; filtering the data through the application of algorithms to extract parametric values; and interfacing with analytics and business intelligence tools for combinatorial and statistical analysis of parameters. This allows specific indicators of symptoms, behaviour, and outcomes of the system to be obtained, and to interface with knowledge management tools to interpret the situation, and predict possible causes, future outcomes and suggestions for corrective actions if any. It can also learn and improve the accuracy of interpretation, prediction and correction using feedback collected from users, and by tracking system responses to corrective actions.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":" Support decision making on harvest timing and best seed selection based on local conditions"},
            {"name":"Education: Remote learning","description":"Data-driven analysis of teacher and student performance for informed school development"},
            {"name":"Health: Maternal and newborn health","description":"Analyze test results to determine treatment/therapy planning"}
        ]
    }')
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
end
if Workflow.where(slug: 'financial_services').empty?
    w = Workflow.create(name: "Financial Services", slug: "financial_services", description: '{
        "name":"Financial Services",
        "other_names": "eCommerce, Payment platforms",
        "short_desc": "Integration between an organization, its beneficiaries, and the ability to automate banking service functions between the two.",
        "full_desc": "Many organizations need to enable certain financial services with a broad range of stakeholders that can be individuals, banks, credit-card companies, insurance companies, merchants, and government organizations. Financial services may involve remittances, credit, savings, insurance, reimbursements, vouchers, paying bills and invoices, subsidies, etc. Financial services WorkFlow enables smooth cashless secure transactions and simple and rapid transfer of funds.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":"Register and assign unique identifiers to farm, farmer, and household"},
            {"name":"Use Case Education: Remote learning","description":"Register and assign unique identifier to remote learner"},
            {"name":"Health: Maternal and newborn health","description":"Register and assign unique identifiers for mother and newborn"}
        ]
    }')
    w.use_cases << UseCase.where(slug: 'market_linkage').limit(1)[0]
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'emarketplace').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'messaging').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'payments').limit(1)[0]
end
if Workflow.where(slug: 'identification_and_registration').empty?
    w = Workflow.create(name: "Identification and Registration", slug: "identification_and_registration", description: '{
        "name":"Identification And Registration",
        "other_names": "Onboarding",
        "short_desc": "Uniquely identify and collect other pertinent information about people and relevant business objects (inventory, locations, or events) for any particular business process.",
        "full_desc": "Organizations need to register persons, facilities, professionals, equipment, procedures, etc in such a way as to be able to uniquely identify them, access their information and grant appropriate access and permissions to transact with them. Identification and registration WorkFlow enable the creation of ‘functional registries’ which provide directory services for different purposes. During the registration process, a unique identifier of an entity is attributed, basic profiling (demographic and/or geographic) information is collected and identity is mapped to already existing national identifiers if any. Registration WorkFlows ensure the enrolment of entities in different programmes and their access to certain entitlements.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":"Register and assign unique identifiers to farm, farmer, and household"},
            {"name":"Education: Remote learning","description":"Register and assign unique identifier to remote learner"},
            {"name":"Health: Maternal and newborn health","description":"Register and assign unique identifiers for mother and newborn"}
        ]
    }')
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
    w = Workflow.create(name: "Knowledge Management", slug: "knowledge_management", description: '{
        "name":"Knowledge Management",
        "other_names": "Information architecture",
        "short_desc": "Collect, sort, and archive organizational assets for easy retrieval and assimilation.",
        "full_desc": "Common knowledge management WorkFlow enables the collection, assimilation, classification, linking, searching, sorting and distribution of information assets automatically or on demand to provide meaningful knowledge that can be converted easily into action. Most organizations are involved in knowledge management activities to enhance business processes, build user capacities and improve user experience. They can help to share experiences, predict situations, register/propose best practices in various situations and supply relevant information for decision support. The knowledge management process also link researchers and those who have experience and skills with those who need them.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":"Management of information resources about national and international best practices, crop yields, and rural extension programmes"},
            {"name":"Education: Remote learning","description":"Repository of teacher resources, such as exercises, student handouts, and assignments"},
            {"name":"Health: Maternal and newborn health","description":"Management of health information resources for mothers and their households, and for their caregivers"}
        ]
    }')
    w.building_blocks << BuildingBlock.where(slug: 'content_management').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'elearning').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'security').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'shared_data_repositories').limit(1)[0]
end
if Workflow.where(slug: 'marketplace').empty?
    w = Workflow.create(name: "Marketplace", slug: "marketplace", description: '{
        "name":"Marketplace",
        "other_names": "Trade, commerce",
        "short_desc": "A discovery platform between buyers and sellers, allowing for easy transactions of goods and services.",
        "full_desc": "Many organizations need to enable marketplaces where buyers and sellers can discover each other, negotiate contracts, buy or sale goods and services and make payments to each other. Marketplaces operate on various models depending on the needs of buyers and sellers. Primarily there are three kinds of marketplaces: business-to-consumer (also government-to consumer); business-to-business; and consumer-to-consumer. Key activities in a marketplace are registration by buyers and sellers, who are authenticated by the marketplace operators. It also allows for product, service and price discovery, buyer-seller interaction, payment transaction, fulfilment and after sales support. Marketplace WorkFlow enables promotion and awareness to users about the marketplace, registration of buyers and sellers, identification and authentication of users, and the sending of transactional updates (eg payment processed, shipments, etc) to transacting parties, as well as actuating financial transactions between buyers and sellers or buyers and marketplace operators.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":"Buying and selling of agricultural goods and products"},
            {"name":"Education: Remote learning","description":"Marketplace for academic textbooks"},
            {"name":"Health: Maternal and newborn health","description":"Buying and selling of birth preparedness products and related health items"}
        ]
    }')
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
    w = Workflow.create(name: "Problem Diagnosis", slug: "problem_diagnosis", description: '{
        "name":"Problem Diagnosis",
        "other_names": "Troubleshooting",
        "short_desc": "Build a model of hypothetical diagnoses, iteratively incorporating new data and eliminating invalid diagnoses.",
        "full_desc": "Problem diagnosis WorkFlow involves an iterative process of collecting data and drawing inferences based on predefined algorithms or rules. In this process, a hypothesis about a set of possible causes is inferred based on observable facts (symptoms) and then iteratively the most unlikely causes are ruled out as more and more observable facts are collected, so that in the end, one (or very few) most probable causes can be inferred. A common example of problem diagnosis is identifying nutrient deficiency in plants by observing leaf colours and leaf or fruit damage.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":"Identify nutrient deficiency in plants by observing leaf colours or leaf/fruit damage"},
            {"name":"Education: Remote learning","description":"Support teacher in identifying and addressing student learning challenge"},
            {"name":"Health: Maternal and newborn health","description":"Identify signs of behavioural disorders by incorporating pertinent EHRs."}
        ]
    }')
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'artificial_intelligence').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'workflow_and_algorithm').limit(1)[0]
end
if Workflow.where(slug: 'procurement').empty?
    w = Workflow.create(name: "Procurement", slug: "procurement", description: '{
        "name":"Procurement",
        "other_names": "Inventory management",
        "short_desc": "Management of business functions of procurement planning, purchasing, inventory control, traffic, receiving, incoming inspection and salvage operations.",
        "full_desc": "Almost all organizations are involved in the procurement of consumables, equipment, raw materials, etc. They engage with a large network of purchasing and consuming entities all along a supply chain. Common procurement activities include supporting users in searching and maintaining lists of preferred products and suppliers; aggregating internal demand for various commodities and raising procurement requests; getting and comparing price quotes and terms/conditions; placing orders; receiving bills; triggering payment services; and posting procured items into an inventory management system.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":"Identify local suppliers for seed, fertilizer, and related products"},
            {"name":"Education: Remote learning","description":"Bulk acquisition of school supplies and equipment"},
            {"name":"Health: Maternal and newborn health","description":"Ordering commodities such as pharmaceuticals"}
        ]
    }')
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'emarketplace').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'payments').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'workflow_and_algorithm').limit(1)[0]
end
if Workflow.where(slug: 'remote_monitoring').empty?
    w = Workflow.create(name: "Remote Monitoring", slug: "remote_monitoring", description: '{
        "name":"Remote Monitoring",
        "other_names": "Distributed sensing",
        "short_desc": "The automated collection of real-time (often time-series) data of remote person or object for status check or receiving emergency alerts.",
        "full_desc": "This WorkFlow involves real-time collection of data about a person, an object or an event, without being physically present, exchanging such collected data with other persons or machines and producing inferences in terms of diagnosis report, analytics, etc. Common examples of remote monitoring include remote field monitoring through in-situ and remote sensors, and remote patient monitoring.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":"Record remote weather station data for forecasts and weather alerts"},
            {"name":"Education: Remote learning","description":"Monitor student device usage during remote closed-book exam"},
            {"name":"Health: Maternal and newborn health","description":"Monitor cold chain equipment status"}
        ]
    }')
    w.use_cases << UseCase.where(slug: 'market_linkage').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'reporting_and_dashboards').limit(1)[0]
end
if Workflow.where(slug: 'supply_chain_management').empty?
    w = Workflow.create(name: "Supply Chain Management", slug: "supply_chain_management", description: '{
        "name":"Supply Chain Management",
        "other_names": "Track, manage and optimize all aspects of a supply chain, including avoiding stockouts, minimizing wastage, and providing an audit trail.",
        "short_desc": "The design, planning, execution, control and monitoring of all supply chain activities with the objective of creating net value and synchronizing supply with demand, including avoiding stockouts, minimizing wastage, and providing an audit trail.",
        "full_desc": "Several types of products travel in a supply chain from manufacturers to wholesalers, retailers and end consumers. This WorkFlow optimizes shipment logistics and delivers goods efficiently without loss of quality all the way from the manufacturer to the end consumer, avoiding wastage and associated losses. For example, vaccines have short expiry periods and can become impotent or adversely potent even before expiry dates, if exposed beyond a narrow range of temperature, humidity and brightness of light. Common supply chain management WorkFlow comprises utilities to enable entities across the value chain to receive and respond to customer enquiries; collect and aggregate supplies of different orders based on delivery schedules and geographical regions; organize and track the location and safety of storage conditions; manage stock levels to avoid shortages; track consignments against delivery schedules; and track undelivered inventories against expiry dates, all along the supply chain.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":"Manage supply of seed and shipment and export of harvested crop"},
            {"name":"Education: Remote learning","description":"National distribution of school supplies and equipment to public education facilities"},
            {"name":"Health: Maternal and newborn health","description":"Manage delivery of supplies to the beneficiary"}
        ]
    }')
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
    w = Workflow.create(name: "Work Planning and Coordination", slug: "work_planning_and_coordination", description: '{
        "name":"Work Planning And Coordination",
        "other_names": "Project management, Task tracking",
        "short_desc": "Orchestrate the coordination and timing of activities of teams and team members within an organization.",
        "full_desc": "The delivery of services involves the execution of several activities on both the user and the provider side in a planned WorkFlow with contingencies to absorb uncertainties and variable dependencies. Work planning and coordination WorkFlow provides this functionality. Common work planning and coordination WorkFlow enables the provider side in planning and allocating appropriate resources for various services; managing customer appointments; tracking delivery; managing field workforce; triggering settlements thereof, etc; and enabling users to book and track their service appointments.",
        "sample_mappings": [{"name":"Agriculture: Market linkage","description":"Coordination of market vendors seasonally to accommodate bulk purchasing and sales"},
            {"name":"Education: Remote learning","description":"Initiate scheduling of phone screening interview between student and enrolment advisor based on student’s stated interest in an advanced course"},
            {"name":"Health: Maternal and newborn health","description":"Automate follow up with provider and patient for missed appointments or upon availability of laboratory test results"}
        ]
    }')
    w.use_cases << UseCase.where(slug: 'maternal_and_newborn_health').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'identification_and_authenticatio').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'information_mediator').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'scheduling').limit(1)[0]
    w.building_blocks << BuildingBlock.where(slug: 'workflow_and_algorithm').limit(1)[0]
end
