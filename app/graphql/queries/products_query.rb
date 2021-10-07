module Queries
  class ProductsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ProductType], null: false

    def resolve(search:)
      products = Product.where(parent_product_id: nil).order(:name)
      unless search.blank?
        products = products.name_contains(search)
      end
      products
    end
  end

  class ProductQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::ProductType, null: false

    def resolve(slug:)
      Product.find_by(slug: slug)
    end
  end

  class SearchProductsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    argument :origins, [String], required: false, default_value: []
    argument :sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :organizations, [String], required: false, default_value: []
    argument :sdgs, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []
    argument :use_cases, [String], required: false, default_value: []
    argument :workflows, [String], required: false, default_value: []
    argument :building_blocks, [String], required: false, default_value: []
    argument :product_types, [String], required: false, default_value: []
    argument :with_maturity, Boolean, required: false, default_value: false
    argument :product_deployable, Boolean, required: false, default_value: false

    type Types::ProductType.connection_type, null: false

    def resolve(search:, origins:, sectors:, countries:, organizations:, sdgs:, tags:, 
      use_cases:, workflows:, building_blocks:, with_maturity:, product_deployable:, product_types:)
      products = Product.where(parent_product_id: nil).order(:name)
      if !search.nil? && !search.to_s.strip.empty?
        name_products = products.name_contains(search)
        desc_products = products.joins(:product_descriptions)
                                .where("LOWER(description) like LOWER(?)", "%#{search}%")
        products = products.where(id: (name_products + desc_products).uniq)
      end

      filtered, filtered_building_blocks = filter_building_blocks(sdgs, use_cases, workflows, building_blocks)
      if filtered
        if filtered_building_blocks.empty?
          # Filter is active, but all the filters are resulting in empty building block array.
          # All bb is filtered out, return no product.
          return []
        else
          products = products.joins(:building_blocks)
                             .where(building_blocks: { id: filtered_building_blocks })
        end
      end

      filtered_origins = origins.reject { |x| x.nil? || x.empty? }
      unless filtered_origins.empty?
        products = products.joins(:origins)
                           .where(origins: { id: filtered_origins })
      end

      filtered_tags = tags.reject { |x| x.nil? || x.blank? }
      unless filtered_tags.empty?
        products = products.where("tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or tags @> '{#{filtered_tags.join(',')}}'::varchar[]")
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        projects = Project.joins(:countries)
                          .where(countries: { id: filtered_countries })
        products = products.joins(:projects)
                           .where(projects: { id: projects })
      end

      filtered_sectors = []
      user_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless user_sectors.empty?
        filtered_sectors = user_sectors.clone
      end
      user_sectors.each do |user_sector|
        curr_sector = Sector.find(user_sector)
        if curr_sector.parent_sector_id.nil?
          child_sectors = Sector.where(parent_sector_id: curr_sector.id)
          filtered_sectors += child_sectors.map(&:id)
        end
      end
      unless filtered_sectors.empty?
        products = products.joins(:sectors)
                           .where(sectors: { id: filtered_sectors })
      end

      filtered_organizations = organizations.reject { |x| x.nil? || x.empty? }
      unless filtered_organizations.empty?
        products = products.joins(:organizations)
                           .where(organizations: { id: filtered_organizations })
      end

      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      unless filtered_sdgs.empty?
        products = products.joins(:sustainable_development_goals)
                           .where(sustainable_development_goals: { id: filtered_sdgs })
      end

      if product_deployable
        products = products.where(is_launchable: product_deployable)
      end

      if with_maturity
        products = products.where('maturity_score is not null')
      end

      if !product_types.include?('product_and_dataset') && !product_types.empty?
        unless product_types.include?('product') && product_types.include?('dataset')
          products = products.where(product_type: product_types)
        end
      end

      products.distinct
    end

    def filter_building_blocks(sdgs, use_cases, workflows, building_blocks)
      filtered = false

      use_case_ids = []
      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      unless filtered_sdgs.empty?
        filtered = true
        sdg_numbers = SustainableDevelopmentGoal.where(id: filtered_sdgs)
                                                .select(:number)
        sdg_use_cases = UseCase.joins(:sdg_targets)
                               .where(sdg_targets: { sdg_number: sdg_numbers })
        use_case_ids.concat(sdg_use_cases.ids)
      end

      workflow_ids = []
      filtered_use_cases = use_case_ids.concat(use_cases.reject { |x| x.nil? || x.empty? })
      unless filtered_use_cases.empty?
        filtered = true
        use_case_workflows = Workflow.joins(:use_case_steps)
                                     .where(use_case_steps: { use_case_id: filtered_use_cases })
        workflow_ids.concat(use_case_workflows.ids)
      end

      building_block_ids = []
      filtered_workflows = workflow_ids.concat(workflows.reject { |x| x.nil? || x.empty? })
      unless filtered_workflows.empty?
        filtered = true
        workflow_building_blocks = BuildingBlock.joins(:workflows)
                                                .where(workflows: { id: filtered_workflows })
        building_block_ids.concat(workflow_building_blocks.ids)
      end

      filtered_bbs = building_blocks.reject { |x| x.nil? || x.empty? }
      if !filtered_bbs.empty?
        filtered = true
      end
      building_block_ids.concat(filtered_bbs.map(&:to_i))
      [filtered, building_block_ids]
    end
  end
end
