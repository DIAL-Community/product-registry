require "google/apis/sheets_v4"
require "googleauth"
require "googleauth/stores/file_token_store"
require 'modules/slugger'
include Modules::Slugger

module Modules
  module Projects
    OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
    APPLICATION_NAME = "DIAL Online Catalog".freeze
    CREDENTIALS_PATH = Rails.root.join("lib/assets/credentials.json").freeze
    # The file token.yaml stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    TOKEN_PATH = Rails.root.join("lib/assets/token.yaml").freeze
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY
    
    def sync_spreadsheet(spreadsheet_id, range) 
      ##
      # Ensure valid credentials, either by restoring from the saved credentials
      # files or intitiating an OAuth2 authorization. If authorization is required,
      # the user's default browser will be launched to approve the request.
      #
      # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
      def authorize
        client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
        token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
        authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
        user_id = "default"
        credentials = authorizer.get_credentials user_id
        if credentials.nil?
          url = authorizer.get_authorization_url base_url: OOB_URI
          puts "Open the following URL in the browser and enter the " \
              "resulting code after authorization:\n" + url
          code = gets
          credentials = authorizer.get_and_store_credentials_from_code(
            user_id: user_id, code: code, base_url: OOB_URI
          )
        end
        credentials
      end
  
      # Initialize the API
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = authorize
  
      response = service.get_spreadsheet_values spreadsheet_id, range
  
      response
    end

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