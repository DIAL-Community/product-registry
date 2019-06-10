if UseCase.where(slug: 'market_linkage').empty?
    u = UseCase.create(name: "Market Linkage", sector: Sector.where(slug: 'agriculture').limit(1)[0], slug: "market_linkage", description: "Connecting rural farmers to market information, products, and related services to improve rural incomes.")
    u.sdg_targets << SdgTarget.where(target_number: '2.1').limit(1)[0]
    u.sdg_targets << SdgTarget.where(target_number: '2.2').limit(1)[0]
    u.sdg_targets << SdgTarget.where(target_number: '2.3').limit(1)[0]
end
if UseCase.where(slug: 'rural_advisory_service').empty?
    u = UseCase.create(name: "Rural Advisory Service", sector: Sector.where(slug: 'agriculture').limit(1)[0], slug: "rural_advisory_service", description: "Enhance rural farmer productivity through local outreach and training services.")
    u.sdg_targets << SdgTarget.where(target_number: '2.3').limit(1)[0]
    u.sdg_targets << SdgTarget.where(target_number: '2.4').limit(1)[0]
end
if UseCase.where(slug: 'remote_learning').empty?
    u = UseCase.create(name: "Remote Learning", sector: Sector.where(slug: 'education').limit(1)[0], slug: "remote_learning", description: "Digital content and tools to provide or supplement all types of learning in disconnected or connected environments.")
    u.sdg_targets << SdgTarget.where(target_number: '4.1').limit(1)[0]
    u.sdg_targets << SdgTarget.where(target_number: '4.3').limit(1)[0]
    u.sdg_targets << SdgTarget.where(target_number: '4.4').limit(1)[0]
end
if UseCase.where(slug: 'digital_microinsurance').empty?
    u = UseCase.create(name: "Digital Microinsurance", sector: Sector.where(slug: 'finance').limit(1)[0], slug: "digital_microinsurance", description: "Insurance products targeted to underserved populations that leverage digital mechanisms to improve outreach and delivery.")
    u.sdg_targets << SdgTarget.where(target_number: '8.3').limit(1)[0]
    u.sdg_targets << SdgTarget.where(target_number: '8.10').limit(1)[0]
end
if UseCase.where(slug: 'mobile_payments').empty?
    u = UseCase.create(name: "Mobile Payments", sector: Sector.where(slug: 'finance').limit(1)[0], slug: "mobile_payments", description: "Enable digital payments between parties, including P2P payments, bulk payments (e.g. C2C, G2C), bill payments (e.g. C2B, C2G), merchant payments, airtime top-up, and international remittances.")
    u.sdg_targets << SdgTarget.where(target_number: '8.2').limit(1)[0]
    u.sdg_targets << SdgTarget.where(target_number: '8.3').limit(1)[0]
end
if UseCase.where(slug: 'maternal_and_newborn_health').empty?
    u = UseCase.create(name: "Maternal and Newborn Health", sector: Sector.where(slug: 'health').limit(1)[0], slug: "maternal_and_newborn_health", description: "Care for mother and child spanning the prenatal and postnatal periods resulting in a healthy mother and child.")
    u.sdg_targets << SdgTarget.where(target_number: '3.1').limit(1)[0]
    u.sdg_targets << SdgTarget.where(target_number: '3.2').limit(1)[0]
end
if UseCase.where(slug: 'communicable_disease_management').empty?
    u = UseCase.create(name: "Communicable Disease Management", sector: Sector.where(slug: 'health').limit(1)[0], slug: "communicable_disease_management", description: "The coordination, diagnosis, and treatment of communicable diseases, such as HIV/AIDS or tuberculosis, often by teams of care providers across community and health care facility settings.")
    u.sdg_targets << SdgTarget.where(target_number: '3.1').limit(1)[0]
end
if UseCase.where(slug: 'beneficiary_case_management').empty?
    u = UseCase.create(name: "Beneficiary Case Management", sector: Sector.where(slug: 'humanitarian').limit(1)[0], slug: "beneficiary_case_management", description: "Enrollment and tracking of beneficiaries and their household to deliver, coordinate, and monitor humanitarian services")
    u.sdg_targets << SdgTarget.where(target_number: '2.1').limit(1)[0]
end
if UseCase.where(slug: 'seed_and_gene_banks').empty?
    u = UseCase.create(name: "Seed and Gene Banks", sector: Sector.where(slug: 'agriculture').limit(1)[0], slug: "seed_and_gene_banks")
end
if UseCase.where(slug: 'biodiversity_monitoring').empty?
    u = UseCase.create(name: "Biodiversity Monitoring", sector: Sector.where(slug: 'agriculture').limit(1)[0], slug: "biodiversity_monitoring")
end
if UseCase.where(slug: 'integrated_disease_surveillance').empty?
    u = UseCase.create(name: "Integrated Disease Surveillance and Response", sector: Sector.where(slug: 'health').limit(1)[0], slug: "integrated_disease_surveillance")
end
if UseCase.where(slug: 'vaccine_management').empty?
    u = UseCase.create(name: "Vaccine Management", sector: Sector.where(slug: 'health').limit(1)[0], slug: "vaccine_management")
end
if UseCase.where(slug: 'learning_communities').empty?
    u = UseCase.create(name: "Learning Communities for Girls and Vulnerable Persons", sector: Sector.where(slug: 'education').limit(1)[0], slug: "learning_communities")
end
if UseCase.where(slug: 'food_assistance').empty?
    u = UseCase.create(name: "Food Assistance", sector: Sector.where(slug: 'humanitarian').limit(1)[0], slug: "food_assistance", description: "A food assistance program for Syrian refugees living in Jordan that utilizes biometric data (eye scans and fingerprints) to distribute food credit and track purchases from local shop owners.")
    u.sdg_targets << SdgTarget.where(target_number: '2.1').limit(1)[0]
end
if UseCase.where(slug: 'vaccine_delivery').empty?
    u = UseCase.create(name: "Vaccine Delivery", sector: Sector.where(slug: 'health').limit(1)[0], slug: "vaccine_delivery", description: "A pharmaceutical and vaccine delivery program for remote populations in Rwanda that uses UAV technology.")
end
if UseCase.where(slug: 'connecting_health_services_to_demand').empty?
    u = UseCase.create(name: "Connecting Health Services to Demand", sector: Sector.where(slug: 'health').limit(1)[0], slug: "connecting_health_services_to_demand", description: "A service operating in conflict zones in the Middle East that uses WhatsApp, Facebook Messenger, and SMS to connect patients with healthcare providers.")
end
if UseCase.where(slug: 'agriculture_extension').empty?
    u = UseCase.create(name: "Agriculture Extension", sector: Sector.where(slug: 'agriculture').limit(1)[0], slug: "agriculture_extension", description: "An agriculture extension program for cassava farmers in Zambia to improve crop yields and manage pests that includes a SMS campaign component with planting tips.")
end
if UseCase.where(slug: 'job_seeking_services').empty?
    u = UseCase.create(name: "Job Seeking Services", sector: Sector.where(slug: 'economicsfinance').limit(1)[0], slug: "job_seeking_services", description: "An employment program in Ramallah, Palestine that allows job seekers to upload resumes, apply for opportunities, and communicate directly with employers through the use of SMS service.")
end