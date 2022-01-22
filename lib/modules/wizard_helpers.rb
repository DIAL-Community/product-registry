module Modules
  module WizardHelpers
    def get_sector_list(sector, subsector)
      sector_ids = []

      sector_name = sector.first
      if !subsector.nil? && !subsector.first.nil? && subsector.first != ''
        sector_name += ":" + subsector.first
      end
      curr_sector = Sector.find_by(name: sector_name)

      unless curr_sector.nil?
        sector_ids = [curr_sector.id]
        if curr_sector.parent_sector_id.nil?
          (sector_ids << Sector.where(parent_sector_id: curr_sector.id).map(&:id)).flatten!
        end
      end

      puts "SECTOR IDS: " + sector_ids.to_s
      puts "CURR SECTOR: " + curr_sector.to_s
      return sector_ids, curr_sector
    end

    def get_project_list(sector_ids, curr_sector, countries, tags, sort_hint)
      if !sector_ids.empty?
        sector_projects = ProjectsSector.where(sector_id: sector_ids).map(&:project_id)
        if sector_projects.empty? && !curr_sector.parent_sector_id.nil?
          sector_projects = ProjectsSector.where(sector_id: curr_sector.parent_sector_id).map(&:project_id)
        end
      end

      unless countries.nil?
        country_projects = ProjectsCountry.joins(:country).where(countries: { name: countries }).map(&:project_id)
      end

      unless tags.nil?
        tag_projects = []
        tags.each do |tag|
          tag_projects += Project.where(':tag = ANY(projects.tags)', tag: tag).map(&:id)
        end
      end

      project_list = filter_matching_projects(sector_projects, country_projects, tag_projects, sort_hint)
      project_list
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