require 'modules/slugger'
include Modules::Slugger

module Modules
  module Projects
    def create_project_entry(orgs, prods, country, origin)

      project_origin = get_origin(origin)
      curr_product = nil
      prods.gsub(/\(.*?\)/, '').gsub(/[\[\]]/,'').split(/[\/,&\n]/).each do |prod|
        prod_search = prod.gsub(/\(.*?\)/, '').strip.downcase
        curr_product = Product.find_by("LOWER(name) LIKE ? OR ? = ANY(LOWER(aliases::text)::text[])", "%"+prod_search+"%", prod_search)
        if curr_product.nil?
          puts "NO PRODUCT: " + prod_search
        end
      end

      country_search = "%"+country.gsub('-',' ').strip.downcase+"%"
      curr_location = Location.find_by("LOWER(name) LIKE ? OR ? = ANY(LOWER(aliases::text)::text[])", country_search, country_search)
      if curr_location.nil?
        puts "NO LOCATION: " + country
      end

      # Split org by '/' and try to find an org to match each
      curr_org = nil
      orgs.gsub(/\(.*?\)/, '').gsub(/[\[\]]/,'').split(/[\/,&\n]/).each do |org|
        if !org.blank?
          org_search = org.strip.downcase
          curr_org = Organization.find_by("LOWER(name) LIKE ? OR ? = ANY(LOWER(aliases::text)::text[])", "%"+org_search+"%", org_search)
          if curr_org.nil? 
            puts "NO ORG: " + org
          end
        end
      end

      if !curr_product.nil? && !curr_location.nil? && !curr_org.nil?
        project_name = curr_product.name + ", " + curr_location.name + ", " + curr_org.name
        curr_project = Project.find_by("name = ?", project_name)
        if curr_project.nil?
          puts "GOT A PROJECT: " + project_name
          curr_project = Project.new
          curr_project.origin_id = project_origin.id
          curr_project.name = project_name
          curr_project.slug = slug_em(project_name)
          curr_project.organizations << curr_org
          curr_project.locations << curr_location
          curr_project.save
        end
      end
    end

    def get_origin(origin)
      project_origin = Origin.find_by(name: origin)
      if project_origin.nil?
        project_origin = Origin.new
        project_origin.name = origin
        project_origin.slug = slug_em project_origin.name
        project_origin.description = origin

        if project_origin.save
          puts project_origin.name + ' as origin is created.'
        end
      end
      project_origin
    end
  end
end