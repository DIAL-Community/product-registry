module Queries

  class WizardQuery < Queries::BaseQuery
    argument :sector, String, required: false
    argument :subsector, String, required: false
    argument :sdg, String, required: false
    argument :buildingBlocks, [String], required: false
    argument :tags, [String], required: false
    argument :country, String, required: false
    argument :mobileServices, [String], required: false

    type Types::WizardType, null: false

    def resolve(sector:, subsector:, sdg:, buildingBlocks:, tags:, country:, mobileServices:)
      wizard = {}
      principles = {}

      wizard['digital_principles'] = DigitalPrinciple.all

      sector_name = sector
      if !subsector.nil? && subsector != ''
        sector_name += ":" + subsector
      end
      currSector = Sector.find_by(name: sector_name)
      currSDG = SustainableDevelopmentGoal.find_by(name: sdg)
      country = Country.find_by(name: country)
      
      sectorUseCases = []
      sdgUseCases = []

      if !currSector.nil?
        sector_ids = [currSector.id]
        if currSector.parent_sector_id.nil?
          (sector_ids << Sector.where(parent_sector_id: currSector.id).map(&:id)).flatten!
        end
        sectorProjects = ProjectsSector.where(sector_id: sector_ids).map(&:project_id)
        if sectorProjects.length == 0 && !currSector.parent_sector_id.nil?
          sectorProjects = ProjectsSector.where(sector_id: currSector.parent_sector_id).map(&:project_id)
        end
        sectorProducts = ProductSector.where(sector_id: sector_ids).map(&:product_id)
        if !currSector.parent_sector_id.nil?
          sector_ids << currSector.parent_sector_id
        end
        sectorUseCases = UseCase.where(sector_id: sector_ids, maturity: "MATURE")
      end
      if !currSDG.nil?
        currTargets = SdgTarget.where(sdg_number: currSDG.number)
        sdgUseCases = UseCase.where("id in (select use_case_id from use_cases_sdg_targets where sdg_target_id in (?)) and maturity='MATURE'", currTargets.ids)
      end
      wizard['use_cases'] = (sectorUseCases + sdgUseCases).uniq

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

      wizard['building_blocks'] = BuildingBlock.where(name: buildingBlocks)
      # Build list of resources manually
      wizard['resources'] = Resource.all

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
      if !mobileServices.empty? && !country.nil?
        aggregators = AggregatorCapability.where('country_id = ? AND service IN (?)', country.id, mobileServices).map(&:aggregator_id)
        wizard['organizations'] = Organization.where(id: aggregators)
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
        if combinedProjects && combinedProjects.length > 0
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
        if combinedProducts && combinedProducts.length > 2
          sectorTagProducts = combinedProducts
        end
      end

      if sectorTagProducts.length > 10 && !productBB.nil?
        # Since we have several products, try filtering by BB
        combinedProducts = sectorTagProducts & productBB
        if combinedProducts && combinedProducts.length > 2
          sectorTagProducts = combinedProducts
        end
      elsif sectorTagProducts.length == 0 && !productBB.nil?
        sectorTagProducts = productBB
      end

      if sectorTagProducts.length > 10 && !productProject.nil?
        # Since we have several products, try filtering by project
        combinedProducts = sectorTagProducts & productProject
        if combinedProducts && combinedProducts.length > 4
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