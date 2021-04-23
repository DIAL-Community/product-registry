module Queries

  class WizardQuery < Queries::BaseQuery
    argument :phase, String, required: true
    argument :sector, String, required: false
    argument :buildingBlocks, [String], required: false
    argument :tags, [String], required: false
    argument :country, String, required: false
    argument :mobileServices, [String], required: false

    type Types::WizardType, null: false

    def resolve(phase:, sector:, buildingBlocks:, tags:, country:, mobileServices:)
      wizard = {}
      principles = {}

      principles['Ideation'] = ['understand_existing_ecosystem', 'design_with_the_user', 'reuse_and_improve']
      principles['Planning'] = ['design_with_the_user', 'design_for_scale', 'be_collaborative']
      principles['Implementation'] = ['be_data_driven', 'use_open_standards', 'address_privacy_security']
      principles['Evaluation'] = ['be_data_driven', 'be_collaborative', 'understand_existing_ecosystem']

      wizard['digital_principles'] = DigitalPrinciple.where(slug: principles[phase])

      currSector = Sector.find_by(name: sector)
      country = Country.find_by(name: country)
      
      if phase == 'Ideation'
        if !currSector.nil?
          sectorProjects = ProjectsSector.where(sector_id: currSector.id).map(&:project_id)
          useCases = UseCase.where(sector_id: currSector.id)
          wizard['use_cases'] = UseCase.where(sector_id: currSector.id)
        end

        if !country.nil?
          countryProjects = ProjectsCountry.where(country_id: country.id).map(&:project_id)
        end

        if !tags.nil?
          tagProjects = []
          tags.each do |tag|
            tagProjects += Project.where(':tag = ANY(projects.tags)', tag: tag).map(&:id)
          end
        end

        project_list = filter_matching_projects(sectorProjects, countryProjects, tagProjects)

        wizard['projects'] = project_list
      end

      if phase == 'Planning'
        wizard['building_blocks'] = BuildingBlock.where(name: buildingBlocks)
        # Build list of resources manually
        wizard['resources'] = [{name: 'D4D Handbook', image_url: 'https://solutions.dial.community//assets/playbooks/pictures/608/PLAYBOOK_FOR_CATALOG.png', link: 'https://resources.dial.community/resources/md4d_handbook'}, 
            {name: 'Procurement Guide', image_url: '', link: 'https://procurement-digitalimpactalliance.org'}]
      end

      if phase == 'Implementation'
        bbs = BuildingBlock.where(name: buildingBlocks)
        productBB = ProductBuildingBlock.where(building_block_id: bbs).map(&:product_id)
        wizard['products'] = Product.where(id: productBB)
        if !mobileServices.empty?
          aggregators = AggregatorCapability.where('country_id = ? AND service IN (?)', country.id, mobileServices).map(&:aggregator_id)
          wizard['organizations'] = Organization.where(id: aggregators)
        end
      end

      if phase == 'Evaluation'
        # Build list of resources manually
        wizard['resources'] = [{name: 'Valuing Impact Toolkit', image_url: '', link: 'https://resources.dial.community/resources/valuing_impact_toolkit'}]
      end

      wizard
    end

    def filter_matching_projects(sectorProjects, countryProjects, tagProjects)

      sectorTagProjects = []
      if !sectorProjects.nil? 
        sectorTagProjects = sectorProjects
      end
      if !tagProjects.nil?
        sectorTagProjects = (sectorTagProjects + tagProjects).uniq
      end
      if sectorTagProjects.length > 5
        # Find projects that match both sector and tag
        combinedProjects = sectorProjects & tagProjects
        if combinedProjects.length > 0
          sectorTagProjects = combinedProjects
        end
      end

      if sectorTagProjects.length > 10 && !countryProjects.nil?
        # Since we have several projects, try filtering by country
        combinedProjects = sectorTagProjects & countryProjects
        if combinedProjects.length > 0
          sectorTagProjects = combinedProjects
        end
      end

      project_list = Project.where(id: sectorTagProjects)
      project_list.first(10)
    end
  end
end