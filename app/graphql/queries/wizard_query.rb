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
      
      if phase == 'Ideation' || phase == 'Implementation'
        if !currSector.nil?
          sectorProjects = ProjectsSector.where(sector_id: currSector.id).map(&:project_id)
          sectorProducts = ProductSector.where(sector_id: currSector.id).map(&:product_id)
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

        if phase == 'Ideation'
          wizard['projects'] = project_list
        end
      end

      if phase == 'Planning'
        wizard['building_blocks'] = BuildingBlock.where(name: buildingBlocks)
        # Build list of resources manually
        wizard['resources'] = Resource.where(phase: phase)
      end

      if phase == 'Implementation'
        bbs = BuildingBlock.where(name: buildingBlocks)
        productBB = ProductBuildingBlock.where(building_block_id: bbs).map(&:product_id)
        productProject = ProjectsProduct.where(project_id: project_list).map(&:product_id)
        if !tags.nil?
          tagProducts = []
          tags.each do |tag|
            tagProducts += Product.where('LOWER(:tag) = ANY(LOWER(products.tags::text)::text[])', tag: tag).map(&:id)
          end
        end

        product_list = filter_matching_products(productBB, productProject, sectorProducts, tagProducts)

        wizard['products'] = product_list
        if !mobileServices.empty?
          aggregators = AggregatorCapability.where('country_id = ? AND service IN (?)', country.id, mobileServices).map(&:aggregator_id)
          wizard['organizations'] = Organization.where(id: aggregators)
        end
      end

      if phase == 'Evaluation'
        # Build list of resources manually
        wizard['resources'] = Resource.where(phase: phase)
      end

      wizard
    end

    def filter_matching_projects(sectorProjects, countryProjects, tagProjects)
      # Filter first by sector and tag and combine. 
      # If there are more than 5 then find projects that match both sector and tag
      # If we have less than 10 results, add in projects that are connected to selected country
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
      elsif sectorTagProjects.length == 0 && !countryProjects.nil?
        sectorTagProjects = countryProjects
      end

      project_list = Project.where(id: sectorTagProjects)
      project_list.first(10)
    end

    def filter_matching_products(productBB, productProject, productSector, productTag)
      # First, identify products that are aligned with selected sector and tags
      # Next, identify products that are aligned with needed building blocks
      # Finally, add products that are connected to relevant projects

      sectorTagProducts = []
      if !productSector.nil? 
        sectorTagProducts = productSector
      end
      if !productTag.nil?
        sectorTagProducts = (sectorTagProducts + productTag).uniq
      end
      if sectorTagProducts.length > 5
        # Find projects that match both sector and tag
        combinedProducts = productSector & productTag
        if combinedProducts.length > 0
          sectorTagProducts = combinedProducts
        end
      end

      if sectorTagProducts.length > 10 && !productBB.nil?
        # Since we have several products, try filtering by BB
        combinedProducts = sectorTagProducts & productBB
        if combinedProducts.length > 0
          sectorTagProducts = combinedProducts
        end
      elsif sectorTagProducts.length == 0 && !productBB.nil?
        sectorTagProducts = productBB
      end

      if sectorTagProducts.length > 10 && !productProject.nil?
        # Since we have several products, try filtering by project
        combinedProducts = sectorTagProducts & productProject
        if combinedProducts.length > 0
          sectorTagProducts = combinedProducts
        end
      elsif sectorTagProducts.length == 0 && !productProject.nil?
        sectorTagProducts = productProject
      end

      product_list = Product.where(id: sectorTagProducts)
      product_list.first(10)
    end

  end
end