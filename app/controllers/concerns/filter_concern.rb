module FilterConcern
  extend ActiveSupport::Concern

  def filter_building_blocks(all_filters=nil, filter_set=nil, project_product_ids = nil, org_ids = nil, org_products = nil, products = nil)
    if all_filters.nil? 
      all_filters, filter_set = sanitize_all_filters
    end

    # Filter out organizations based on filter input.
    org_ids.nil? && org_ids = get_organizations_from_filters(all_filters)
    project_product_ids.nil? && project_product_ids = get_products_from_projects(all_filters, org_ids)

    bb_projects = []
    if !project_product_ids.empty?
      bb_projects = BuildingBlock.joins(:products)
                                 .where('products.id in (?)', project_product_ids)
                                 .ids
    end

    sdg_workflows = get_workflows_from_sdgs(all_filters["sdgs"])
    use_case_workflows = get_workflows_from_use_cases(all_filters["use_cases"])

    bb_workflows = []
    workflow_ids = filter_and_intersect_arrays([all_filters["workflows"], sdg_workflows, use_case_workflows])
    if !workflow_ids.nil? && !workflow_ids.empty?
      bb_workflows = BuildingBlock.joins(:workflows)
                                  .where('workflows.id in (?)', workflow_ids)
                                  .ids
    end

    products.nil? && products = get_products_from_filters(all_filters)

    org_products.nil? && org_products = get_org_products(all_filters)

    bb_products = []
    bb_products_ids = filter_and_intersect_arrays([org_products, products])
    if !bb_products_ids.empty?
      bb_products = BuildingBlock.joins(:products)
                                 .where('products.id in (?)', bb_products_ids)
                                 .ids
    end

    if filter_set
      ids = filter_and_intersect_arrays([bb_workflows, bb_products, all_filters["bbs"], bb_projects])
      BuildingBlock.where(id: ids).order(:slug)
    else
      BuildingBlock.order(:slug)
    end
  end

  def filter_workflows(all_filters=nil, filter_set=nil, project_product_ids = nil, org_ids = nil, org_products = nil, products = nil)
    if all_filters.nil? 
      all_filters, filter_set = sanitize_all_filters
    end

    sdg_use_cases = get_use_cases_from_sdgs(all_filters["sdgs"])
    use_case_ids = filter_and_intersect_arrays([sdg_use_cases, all_filters["use_cases"]])
    use_case_workflow_ids = get_workflows_from_use_cases(use_case_ids)

    # Filter out organizations based on filter input.
    org_ids.nil? && org_ids = get_organizations_from_filters(all_filters)
    project_product_ids.nil? && project_product_ids = get_products_from_projects(all_filters, org_ids)

    sdg_products = []
    org_products.nil? && org_products = get_org_products(all_filters)

    products.nil? && products = get_products_from_filters(all_filters)

    product_bbs = []
    product_ids = filter_and_intersect_arrays([products, sdg_products, org_products, project_product_ids])
    if !product_ids.nil? && !product_ids.empty?
      product_bbs = get_bbs_from_products(product_ids)
    end

    bb_workflow_ids = []
    bb_ids = filter_and_intersect_arrays([all_filters["bbs"], product_bbs])
    if !bb_ids.nil? && !bb_ids.empty?
      bb_workflow_ids = Workflow.joins(:building_blocks)
                                .where('building_blocks.id in (?)', bb_ids)
                                .ids
    end

    if filter_set
      ids = filter_and_intersect_arrays([all_filters["workflows"], use_case_workflow_ids, bb_workflow_ids])
      Workflow.where(id: ids).order(:slug)
    else
      Workflow.order(:slug)
    end
  end

  def filter_use_cases(all_filters=nil, filter_set=nil, project_product_ids = nil, org_ids = nil, org_products = nil, products = nil)

    if all_filters.nil? 
      all_filters, filter_set = sanitize_all_filters
    end

    sdg_uc_ids = []
    if !all_filters["sdgs"].empty?
      # Get use_cases connected to this sdg
      sdgs = SustainableDevelopmentGoal.where(id: all_filters["sdgs"])
                                       .select(:number)
      sdg_targets = SdgTarget.where('sdg_number in (?)', sdgs)
      sdg_use_cases = UseCase.joins(:sdg_targets)
                             .where('sdg_targets.id in (?)', sdg_targets.ids)
      sdg_uc_ids = sdg_use_cases.ids
    end

    # Filter out organizations based on filter input.
    org_ids.nil? && org_ids = get_organizations_from_filters(all_filters)
    project_product_ids.nil? && project_product_ids = get_products_from_projects(all_filters, org_ids)

    sdg_products = []
    org_products.nil? && org_products = get_org_products(all_filters)

    products.nil? && products = get_products_from_filters(all_filters)

    workflow_product_ids = []
    product_ids = filter_and_intersect_arrays([products, sdg_products, org_products, project_product_ids])
    if !product_ids.nil? && !product_ids.empty?
      workflow_product_ids = get_workflows_from_products(product_ids)
    end

    workflow_bb_ids = get_workflows_from_bbs(all_filters["bbs"])

    uc_workflows = []
    workflow_ids = filter_and_intersect_arrays([all_filters["workflows"], workflow_product_ids, workflow_bb_ids])
    if !workflow_ids.nil? && !workflow_ids.empty?
      uc_workflows += UseCaseStep.joins(:workflows)
                                 .where('workflows.id in (?)', workflow_ids)
                                 .select('use_case_id')
                                 .pluck('use_case_id')
    end

    if filter_set
      ids = filter_and_intersect_arrays([all_filters["use_cases"], sdg_uc_ids, uc_workflows])
      @use_cases = UseCase.where(id: ids).order(:slug)
    else
      @use_cases = UseCase.order(:slug)
    end

    if !params[:beta].present? || params[:beta].to_s.downcase == 'false'
      @use_cases = @use_cases.where(':tag = use_cases.maturity', tag: 'MATURE')
    end
    @use_cases
  end

  def filter_sdgs(all_filters=nil, filter_set=nil, project_product_ids = nil, org_ids = nil, org_products = nil, products = nil)

    if all_filters.nil? 
      all_filters, filter_set = sanitize_all_filters
    end

    # Filter out organizations based on filter input.
    org_ids.nil? && org_ids = get_organizations_from_filters(all_filters)
    project_product_ids.nil? && project_product_ids = get_products_from_projects(all_filters, org_ids)

    sdg_products = []
    org_products.nil? && org_products = get_org_products(all_filters)
    products.nil? && products = get_products_from_filters(all_filters)

    workflow_product_ids = []
    product_ids = filter_and_intersect_arrays([products, sdg_products, org_products, project_product_ids])
    if !product_ids.nil? && !product_ids.empty?
      workflow_product_ids = get_workflows_from_products(product_ids)
    end

    workflow_bb_ids = get_workflows_from_bbs(all_filters["bbs"])

    uc_workflows = []
    workflow_ids = filter_and_intersect_arrays([all_filters["workflows"], workflow_product_ids, workflow_bb_ids])
    if !workflow_ids.nil? && !workflow_ids.empty?
      uc_workflows += UseCaseStep.joins(:workflows)
                                 .where('workflows.id in (?)', workflow_ids)
                                 .select('use_case_id')
                                 .pluck('use_case_id')
    end

    sdg_uc_ids = filter_and_intersect_arrays([all_filters["use_cases"], uc_workflows])

    sdg_numbers = []
    if !sdg_uc_ids.nil? && !sdg_uc_ids.empty?
      sdg_numbers = UseCase.joins(:sdg_targets)
                           .where('use_cases.id in (?)', sdg_uc_ids)
                           .select('sdg_number')
                           .pluck('sdg_number')
    end

    if filter_set
      goals = SustainableDevelopmentGoal
      if !all_filters["sdgs"].nil? && !all_filters["sdgs"].empty?
        goals = goals.where(id: all_filters["sdgs"])
        if !sdg_numbers.empty?
          goals = goals.or(SustainableDevelopmentGoal.where(number: sdg_numbers))
        end
      elsif !sdg_numbers.empty?
        goals = goals.where(number: sdg_numbers)
      else
        # Nothing is matching the criteria. Return nothing.
        goals = SustainableDevelopmentGoal.none
      end
      goals
    else
      SustainableDevelopmentGoal.order(:number)
    end
  end

  def filter_projects(all_filters=nil, filter_set=nil, project_product_ids = nil, org_ids = nil, org_products = nil, products = nil)
    if all_filters.nil? 
      all_filters, filter_set = sanitize_all_filters
    end

    all_projects = Project.order(:slug)
    if !filter_set
      return all_projects
    end

    if !all_filters["project_origins"].empty?
      all_projects = all_projects.where('origin_id in (?)', all_filters["project_origins"])
    end

    country_project_ids = []
    if !all_filters["countries"].empty?
      country_project_ids = all_projects.joins(:countries)
                                .where('country_id in (?)', all_filters["countries"])
                                .ids
    end

    tag_project_ids = []
    if !all_filters["tags"].empty?
      tag_project_ids = all_projects.where("tags @> '{#{all_filters["tags"].join(',')}}'::varchar[]")
                                .ids
    end

    sdg_products = []
    if !all_filters["sdgs"].empty?
      sdg_products += Product.joins(:sustainable_development_goals)
                             .where('sustainable_development_goal_id in (?)', all_filters["sdgs"])
                             .ids
    end

    use_case_bbs = get_bbs_from_use_cases(all_filters["use_cases"])
    workflow_bbs = get_bbs_from_workflows(all_filters["workflows"])

    bb_products = []
    bb_ids = filter_and_intersect_arrays([all_filters["bbs"], use_case_bbs, workflow_bbs])
    if !bb_ids.nil? && !bb_ids.empty?
      bb_products += Product.joins(:building_blocks)
                            .where('building_blocks.id in (?)', bb_ids)
                            .ids
    end

    products.nil? && products = get_products_from_filters(all_filters)

    product_project_ids = []
    product_ids = filter_and_intersect_arrays([sdg_products, bb_products, products])
    if !products.nil? && !products.empty?
      product_project_ids += all_projects.joins(:products)
                                    .where('products.id in (?)', products)
                                    .ids
    end

    project_filtered_ids = filter_and_intersect_arrays([all_filters["projects"], all_projects.ids, country_project_ids, tag_project_ids, product_project_ids])

    projects = all_projects.where(id: project_filtered_ids).order(:slug)

    return projects
  end

  def filter_products(all_filters=nil, filter_set=nil, project_product_ids = nil, org_ids = nil, org_products = nil, products = nil)
    if all_filters.nil? 
      all_filters, filter_set = sanitize_all_filters
    end

    if !filter_set
      return Product.where(is_child: false)
    end

    # Filter out organizations based on filter input.
    org_ids.nil? && org_ids = get_organizations_from_filters(all_filters)
    project_product_ids.nil? && project_product_ids = get_products_from_projects(all_filters, org_ids)

    org_products.nil? && org_products = get_org_products(all_filters)

    sdg_products = org_products
    unless all_filters["sdgs"].empty?
      sdg_products += Product.joins(:sustainable_development_goals)
                             .where('sustainable_development_goal_id in (?)', all_filters["sdgs"])
                             .ids
    end

    use_case_bbs = get_bbs_from_use_cases(all_filters["use_cases"])
    workflow_bbs = get_bbs_from_workflows(all_filters["workflows"])

    bb_products = []
    bb_ids = filter_and_intersect_arrays([all_filters["bbs"], use_case_bbs, workflow_bbs])
    if !bb_ids.nil? && !bb_ids.empty?
      bb_products += Product.joins(:building_blocks)
                            .where('building_blocks.id in (?)', bb_ids)
                            .ids
    end

    products.nil? && products = get_products_from_filters(all_filters)
    filter_and_intersect_arrays([products, sdg_products, bb_products])
  end

  def filter_organizations(all_filters=nil, filter_set=nil, project_product_ids = nil, org_ids = nil, org_products = nil, products = nil)
    if all_filters.nil? 
      all_filters, filter_set = sanitize_all_filters
    end

    if !filter_set
      return Organization.order(:slug)
    end

    sdg_products = []
    unless all_filters["sdgs"].empty?
      sdg_products = Product.joins(:sustainable_development_goals)
                            .where('sustainable_development_goal_id in (?)', all_filters["sdgs"])
                            .ids
    end

    use_case_bbs = get_bbs_from_use_cases(all_filters["use_cases"])
    workflow_bbs = get_bbs_from_workflows(all_filters["workflows"])

    bb_products = []
    bb_ids = filter_and_intersect_arrays([all_filters["bbs"], use_case_bbs, workflow_bbs])
    if !bb_ids.nil? && !bb_ids.empty?
      bb_products = Product.joins(:building_blocks)
                           .where('building_blocks.id in (?)', bb_ids)
                           .ids
    end

    project_products = []
    unless all_filters["projects"].empty?
      project_products += Project.joins(:products)
                                 .where('projects.id in (?)', all_filters["projects"])
                                 .select('products.id')
    end

    products.nil? && products = get_products_from_filters(all_filters)

    org_products = []
    product_ids = filter_and_intersect_arrays([sdg_products, bb_products, project_products, products])
    if !product_ids.nil? && !product_ids.empty?
      org_products = Organization.joins(:products)
                                 .where('products.id in (?)', product_ids)
                                 .ids
    end

    product_project_ids = []
    if !product_ids.nil? && !product_ids.empty?
      product_project_ids += Project.joins(:products)
                                    .where('products.id in (?)', product_ids)
                                    .ids
    end

    org_projects = []
    project_ids = filter_and_intersect_arrays([all_filters["projects"], product_project_ids])
    if !project_ids.nil? && !project_ids.empty?
      org_projects = Organization.joins(:projects)
                                 .where('projects.id in (?)', project_ids)
                                 .ids
    end

    org_ids.nil? && org_ids = get_organizations_from_filters(all_filters)

    other_filtered = !(all_filters["products"].empty? && all_filters["origins"].empty? && all_filters["projects"].empty? && all_filters["tags"].empty? && all_filters["product_type"].empty? &&
                    all_filters["sdgs"].empty? && all_filters["use_cases"].empty? && all_filters["workflows"].empty? && all_filters["bbs"].empty? && all_filters["countries"].empty?) ||
                    all_filters["with_maturity_assessment"] || all_filters["is_launchable"]

    if (other_filtered)
      filter_org_ids = filter_and_intersect_arrays([org_projects + org_products + org_ids])
    else
      filter_org_ids = org_ids
    end

    organizations = Organization.where(id: filter_org_ids)
  end

  def filter_playbooks(all_filters=nil, filter_set=nil, project_product_ids = nil, org_ids = nil, org_products = nil, products = nil)
    playbooks = []
    if !all_filters["playbooks"].nil? && !all_filters["playbooks"].empty?
      playbooks = Playbook.where(id: all_filters["playbooks"])
    else
      playbooks = Playbook.all
    end
  end

  def get_organizations_from_filters(all_filters)
    # Filter out the organization first based on the arguments.
    org_list = Organization.order(:slug)
    !all_filters["organizations"].empty? && org_list = org_list.where('organizations.id in (?)', all_filters["organizations"])

    if all_filters["endorser_only"] && all_filters["aggregator_only"]
      org_list = org_list.where("is_endorser is true or is_mni is true")
    else
      all_filters["endorser_only"] && org_list = org_list.where(is_endorser: true)
      all_filters["aggregator_only"] && org_list = org_list.where(is_mni: true)
    end

    !all_filters["countries"].empty? && org_list = org_list.joins(:locations).where('locations.id in (?)', all_filters["countries"])
    !all_filters["sectors"].empty? && org_list = org_list.joins(:sectors).where('sectors.id in (?) or sectors.parent_sector_id in (?)', all_filters["sectors"], all_filters["sectors"])
    !all_filters["years"].empty? && org_list = org_list.where('extract(year from when_endorsed) in (?)', all_filters["years"])

    if !session[:portal]['organization_views'].nil?
      if !session[:portal]['organization_views'].include?('endorser')
        org_list = org_list.where.not('is_endorser is true')
      end
      if !session[:portal]['organization_views'].include?('mni')
        org_list = org_list.where.not('is_endorser is false')
      end
      if !session[:portal]['organization_views'].include?('product')
        org_list = org_list.where
                           .not('organizations.id in (select organization_id from organizations_products)')
      end
    end

    org_list.ids
  end

  def get_products_from_projects(all_filters, org_ids)
    project_product_ids = []

    org_filtered = (!all_filters["years"].empty? || !all_filters["organizations"].empty? || all_filters["endorser_only"] || 
              all_filters["aggregator_only"] || !all_filters["sectors"].empty?)

    country_filters = []
    !all_filters["countries"].empty? && country_filters += Project.joins(:locations)
                                                     .where('locations.id in (?)', all_filters["countries"])
                                                     .ids

    !all_filters["projects"].empty? && project_product_ids += Product.joins(:projects)
                                                     .where('projects.id in (?)', all_filters["projects"]+country_filters)
                                                     .ids

    # Filter out project based on organization filter above.
    org_projects = []
    org_filtered && org_projects += Project.joins(:organizations)
                                          .where('organizations.id in (?)', org_ids)
                                          .ids

    # Add products based on the project filtered above.
    !org_projects.empty? && project_product_ids += Product.joins(:projects)
                                                          .where('projects.id in (?)', org_projects)
                                                          .ids
    
    project_product_ids
  end

  def get_org_products(all_filters)
    org_products = []

    if !all_filters["organizations"].empty?
      org_products += Product.joins(:organizations)
                             .where('organization_id in (?)', all_filters["organizations"])
                             .ids
    end
    org_products
  end

  def get_products_from_filters(all_filters)
    # Check to see if the filter has already been set
    product_filter_set = (!all_filters["products"].empty? || !all_filters["origins"].empty? ||
                            !all_filters["tags"].empty? || !all_filters["sectors"].empty? ||
                            all_filters["with_maturity_assessment"] || all_filters["is_launchable"] ||
                            !all_filters["product_type"].empty?)

    product_list = []
    if session[:updated_prod_filter].nil? || session[:updated_prod_filter].to_s.downcase == 'true'
      filter_products = Product.where(is_child: false)
      if !all_filters["products"].empty?
        filter_products = Product.all.where('products.id in (?)', all_filters["products"])
      end

      if !all_filters["origins"].empty?
        origin_list = Origin.where('origins.id in (?)', all_filters["origins"])

        # Also filter origins using the portal configuration.
        if !session[:portal]['product_views'].nil?
          origin_list = origin_list.where('origins.name in (?)', session[:portal]['product_views'])
        end

        # Filter products based on the origin information
        !origin_list.empty? && filter_products = filter_products.joins(:origins)
                                                                .eager_load('origins')
                                                                .where('origins.id in (?)', origin_list.ids)
      end

      if !all_filters["tags"].empty?
        filter_products = filter_products.where("tags @> '{#{all_filters["tags"].map(&:downcase).join(',')}}'::varchar[]")
      end

      if !all_filters["product_type"].empty?
        filter_products = filter_products.where("product_type in (?)", all_filters["product_type"])
      end

      if all_filters["is_launchable"]
        filter_products = filter_products.where('is_launchable is true')
      end

      if all_filters["with_maturity_assessment"]
        filter_products = filter_products.where('maturity_score > 0')
      end

      unless all_filters['sectors'].empty?
        filter_products = filter_products.joins(:sectors)
                                         .where('sectors.id in (?) or sectors.parent_sector_id in (?)', all_filters["sectors"], all_filters["sectors"])
      end

      product_list += filter_products.ids

      # Set the cookies for caching
      session[:updated_prod_filter] = false
      session[:filter_products] = product_list.join(',')
      session[:prod_filter_set] = product_filter_set
    else
      product_filter_set && product_list = session[:filter_products].split(',').map(&:to_i)
    end
    product_list
  end
end