module Queries
  class WizardQuery < Queries::BaseQuery
    argument :sector, String, required: false
    argument :subsector, String, required: false
    argument :sdg, String, required: false
    argument :building_blocks, [String], required: false
    argument :tags, [String], required: false
    argument :countries, [String], required: false
    argument :mobile_services, [String], required: false

    argument :project_sort_hint, String, required: false
    argument :product_sort_hint, String, required: false

    type Types::WizardType, null: false

    def resolve(
      sector:, subsector:, sdg:, building_blocks:, tags:, countries:, mobile_services:,
      project_sort_hint:, product_sort_hint:
    )
      wizard = {}
      wizard['digital_principles'] = DigitalPrinciple.all

      sector_name = sector
      if !subsector.nil? && subsector != ''
        sector_name += ":" + subsector
      end
      curr_sector = Sector.find_by(name: sector_name)
      curr_sdg = SustainableDevelopmentGoal.find_by(name: sdg)
      country = Country.find_by(name: country)

      sector_use_cases = []
      sdg_use_cases = []

      unless curr_sector.nil?
        sector_ids = [curr_sector.id]
        if curr_sector.parent_sector_id.nil?
          (sector_ids << Sector.where(parent_sector_id: curr_sector.id).map(&:id)).flatten!
        end
        sector_projects = ProjectsSector.where(sector_id: sector_ids).map(&:project_id)
        if sector_projects.empty? && !curr_sector.parent_sector_id.nil?
          sector_projects = ProjectsSector.where(sector_id: curr_sector.parent_sector_id).map(&:project_id)
        end
        sector_products = ProductSector.where(sector_id: sector_ids).map(&:product_id)
        unless curr_sector.parent_sector_id.nil?
          sector_ids << curr_sector.parent_sector_id
        end
        sector_use_cases = UseCase.where(sector_id: sector_ids, maturity: "MATURE")
      end
      unless curr_sdg.nil?
        curr_targets = SdgTarget.where(sdg_number: curr_sdg.number)
        sdg_use_cases = UseCase.where(
          "id in (select use_case_id from use_cases_sdg_targets where sdg_target_id in (?)) and maturity='MATURE'",
          curr_targets.ids
        )
      end
      wizard['use_cases'] = (sector_use_cases + sdg_use_cases).uniq

      unless countries.nil?
        country_projects = ProjectsCountry.joins(:country).where(countries: { name: countries }).map(&:project_id)
      end

      unless tags.nil?
        tag_projects = []
        tags.each do |tag|
          tag_projects += Project.where(':tag = ANY(projects.tags)', tag: tag).map(&:id)
        end
      end

      project_list = filter_matching_projects(sector_projects, country_projects, tag_projects, project_sort_hint)

      wizard['projects'] = project_list

      wizard['building_blocks'] = BuildingBlock.where(name: building_blocks)
      # Build list of resources manually
      wizard['resources'] = Resource.all

      bbs = BuildingBlock.where(name: building_blocks)
      product_bb = ProductBuildingBlock.where(building_block_id: bbs).map(&:product_id)
      product_project = ProjectsProduct.where(project_id: project_list).map(&:product_id)
      unless tags.nil?
        tag_products = []
        tags.each do |tag|
          tag_products += Product.where('LOWER(:tag) = ANY(LOWER(products.tags::text)::text[])', tag: tag).map(&:id)
        end
      end

      product_list = filter_matching_products(product_bb, product_project, sector_products, tag_products, product_sort_hint)

      wizard['products'] = product_list
      if !mobile_services.empty? && !country.nil?
        aggregators = AggregatorCapability.where('country_id = ? AND service IN (?)', country.id, mobile_services)
                                          .map(&:aggregator_id)
        wizard['organizations'] = Organization.where(id: aggregators)
      end

      wizard
    end

    def filter_matching_projects(sector_projects, country_projects, tag_projects, sort_hint)
      # Filter first by sector and tag and combine.
      # If there are more than 5 then find projects that match both sector and tag
      # If we have less than 10 results, add in projects that are connected to selected country
      sector_tag_projects = []
      unless sector_projects.nil?
        sector_tag_projects = sector_projects
      end
      unless tag_projects.nil?
        sector_tag_projects = (sector_tag_projects + tag_projects).uniq
      end
      if sector_tag_projects.length > 5
        # Find projects that match both sector and tag
        combined_projects = sector_projects & tag_projects
        if combined_projects && !combined_projects.empty?
          sector_tag_projects = combined_projects
        end
      end

      if sector_tag_projects.length > 10 && !country_projects.nil?
        # Since we have several projects, try filtering by country
        combined_projects = sector_tag_projects & country_projects
        unless combined_projects.empty?
          sector_tag_projects = combined_projects
        end
      end

      project_list = Project
      if sort_hint.to_s.downcase == 'country'
        project_list = project_list.joins(:countries).order('countries.name')
      elsif sort_hint.to_s.downcase == 'sector'
        project_list = project_list.joins(:sectors).order('sectors.name')
      elsif sort_hint.to_s.downcase == 'tag'
        project_list = project_list.order('tags')
      end
      project_list.where(id: sector_tag_projects).order('name').first(20)
    end

    def filter_matching_products(product_bb, product_project, product_sector, product_tag, sort_hint)
      # First, identify products that are aligned with selected sector and tags
      # Next, identify products that are aligned with needed building blocks
      # Finally, add products that are connected to relevant projects

      sector_tag_products = []
      unless product_sector.nil?
        sector_tag_products = product_sector
      end
      unless product_tag.nil?
        sector_tag_products = (sector_tag_products + product_tag).uniq
      end
      if sector_tag_products.length > 5
        # Find projects that match both sector and tag
        combined_products = product_sector & product_tag
        if combined_products && combined_products.length > 2
          sector_tag_products = combined_products
        end
      end

      if sector_tag_products.length > 10 && !product_bb.nil?
        # Since we have several products, try filtering by BB
        combined_products = sector_tag_products & product_bb
        if combined_products && combined_products.length > 2
          sector_tag_products = combined_products
        end
      elsif sector_tag_products.empty? && !product_bb.nil?
        sector_tag_products = product_bb
      end

      if sector_tag_products.length > 10 && !product_project.nil?
        # Since we have several products, try filtering by project
        combined_products = sector_tag_products & product_project
        if combined_products && combined_products.length > 4
          sector_tag_products = combined_products
        end
      elsif sector_tag_products.empty? && !product_project.nil?
        sector_tag_products = product_project
      end

      product_list = Product
      if sort_hint.to_s.downcase == 'country'
        product_list = product_list.joins(:countries).order('countries.name')
      elsif sort_hint.to_s.downcase == 'sector'
        product_list = product_list.joins(:sectors).order('sectors.name')
      elsif sort_hint.to_s.downcase == 'tag'
        product_list = product_list.order('tags')
      end
      product_list.where(id: sector_tag_products).order('name').first(20)
    end
  end
end
