require 'modules/wizard_helpers'

module Queries
  include Modules::WizardHelpers

  class ProductsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ProductType], null: false

    def resolve(search:)
      products = Product.order(:name)
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
    unless filtered_bbs.empty?
      filtered = true
      if filtered_bbs.all? { |i| i.scan(/\D/).empty? }
        building_block_ids.concat(filtered_bbs.map(&:to_i))
      else
        building_block_ids.concat(BuildingBlock.where(name: filtered_bbs).map(&:id))
      end
    end
    [filtered, building_block_ids]
  end

  def filter_products(
    search, origins, sectors, sub_sectors, countries, organizations, sdgs, tags, endorsers,
    use_cases, workflows, building_blocks, with_maturity, product_deployable, product_types,
    sort_hint, offset_params = {}
  )
    products = Product.all
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
      products = products.where(
        "tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or " \
        "tags @> '{#{filtered_tags.join(',')}}'::varchar[]"
      )
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
    user_sectors.each do |user_sector|
      # Find the sector record.
      if user_sector.scan(/\D/).empty?
        sector = Sector.find_by(id: user_sector)
      else
        sector = Sector.find_by(name: user_sector)
      end
      # Skip if we can't find any sector
      next if sector.nil?
      # Add the id to the accepted sector list
      filtered_sectors << sector.id
      # Skip if the parent sector id is empty
      next if sector.parent_sector_id.nil?
      # Iterate over the child sector and match on the subsector if available
      child_sectors = Sector.where(parent_sector_id: sector.id)
      unless sub_sectors.empty?
        child_sectors = child_sectors.select do |child_sector|
          sub_sector_match = false
          sub_sectors.each do |sub_sector|
            # Keepn on skipping if we found a match already
            next if sub_sector_match
            # Try to find a match if we can.
            sub_sector_match = child_sector.name == "#{sector.name}:#{sub_sector}"
          end
          sub_sector_match
        end
      end
      filtered_sectors += child_sectors.map(&:id)
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

    filtered_endorsers = endorsers.reject { |x| x.nil? || x.empty? }
    unless filtered_endorsers.empty?
      products = products.joins(:endorsers)
                         .where(endorsers: { id: filtered_endorsers })
    end

    if sort_hint.to_s.downcase == 'country'
      products = products.joins(:countries).order('countries.name')
    elsif sort_hint.to_s.downcase == 'sector'
      products = products.joins(:sectors).order('sectors.name')
    elsif sort_hint.to_s.downcase == 'tag'
      products = products.order('products.tags')
    else
      products = products.order('products.name')
    end
    products.uniq
  end

  def wizard_products(sectors, sub_sectors, countries, tags, building_blocks, sort_hint, offset_params = {})
    sector_ids, curr_sector = get_sector_list(sectors, sub_sectors)
    unless sector_ids.empty?
      sector_products = ProductSector.where(sector_id: sector_ids).map(&:product_id)
      if sector_products.empty? && !curr_sector.parent_sector_id.nil?
        sector_products = ProductsSector.where(sector_id: curr_sector.parent_sector_id).map(&:product_id)
      end
    end

    project_list = get_project_list(sector_ids, curr_sector, countries, tags, sort_hint).map(&:id).uniq

    bbs = BuildingBlock.where(name: building_blocks)
    product_bb = ProductBuildingBlock.where(building_block_id: bbs).map(&:product_id)
    product_project = ProjectsProduct.where(project_id: project_list).map(&:product_id)
    unless tags.nil?
      tag_products = []
      tags.each do |tag|
        tag_products += Product.where('LOWER(:tag) = ANY(LOWER(products.tags::text)::text[])', tag: tag).map(&:id)
      end
    end

    filter_matching_products(product_bb, product_project, sector_products, tag_products, sort_hint, offset_params).uniq
  end

  class SearchProductsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper
    include Queries

    argument :search, String, required: false, default_value: ''
    argument :origins, [String], required: false, default_value: []
    argument :sectors, [String], required: false, default_value: []
    argument :sub_sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :organizations, [String], required: false, default_value: []
    argument :sdgs, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []
    argument :use_cases, [String], required: false, default_value: []
    argument :workflows, [String], required: false, default_value: []
    argument :building_blocks, [String], required: false, default_value: []
    argument :product_types, [String], required: false, default_value: []
    argument :endorsers, [String], required: false, default_value: []
    argument :with_maturity, Boolean, required: false, default_value: false
    argument :product_deployable, Boolean, required: false, default_value: false

    argument :product_sort_hint, String, required: false, default_value: 'name'
    type Types::ProductType.connection_type, null: false

    def resolve(
      search:, origins:, sectors:, sub_sectors:, countries:, organizations:, sdgs:, tags:, endorsers:,
      use_cases:, workflows:, building_blocks:, with_maturity:, product_deployable:, product_types:,
      product_sort_hint:
    )
      products = filter_products(
        search, origins, sectors, sub_sectors, countries, organizations, sdgs, tags, endorsers,
        use_cases, workflows, building_blocks, with_maturity, product_deployable, product_types,
        product_sort_hint
      )
      products.uniq
    end
  end

  class PaginatedProductsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper
    include Queries

    argument :sectors, [String], required: false, default_value: []
    argument :sub_sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []
    argument :building_blocks, [String], required: false, default_value: []
    argument :offset_attributes, Types::OffsetAttributeInput, required: true

    argument :product_sort_hint, String, required: false, default_value: 'name'
    type Types::ProductType.connection_type, null: false

    def resolve(sectors:, sub_sectors:, countries:, tags:, building_blocks:, product_sort_hint:, offset_attributes:)
      wizard_products(sectors, sub_sectors, countries, tags, building_blocks, product_sort_hint, offset_attributes)
    end
  end

  class EndorsersQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::EndorserType], null: false

    def resolve(search:)
      endorsers = Endorser.order(:name)
      unless search.blank?
        endorsers = endorsers.name_contains(search)
      end
      endorsers
    end
  end

  class ProductRepositoriesQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type [Types::ProductRepositoryType], null: false

    def resolve(slug:)
      product = Product.find_by(slug: slug)
      ProductRepository.where(product_id: product.id, deleted: false).order(main_repository: :desc, name: :asc)
    end
  end

  class ProductRepositoryQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::ProductRepositoryType, null: false

    def resolve(slug:)
      ProductRepository.find_by(slug: slug)
    end
  end
end
