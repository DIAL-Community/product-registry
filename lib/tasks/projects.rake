require "google/apis/sheets_v4"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"
require 'modules/projects'

include Modules::Projects

namespace :projects do
  desc 'Read data from projects spreadsheet (Google)'
  task :sync_spreadsheet, [:path] => :environment do |_, params|

    OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
    APPLICATION_NAME = "DIAL Online Catalog".freeze
    CREDENTIALS_PATH = Rails.root.join("lib/assets/credentials.json").freeze
    # The file token.yaml stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    TOKEN_PATH = Rails.root.join("lib/assets/token.yaml").freeze
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

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

    spreadsheet_id = "1Y6fl3Uqvn0lcFhBlYPXLKKi2HXi79kw8pWR_h8PwE3s"
    range = "1. Partners support to frontline HWs tools!A1:Z"
    response = service.get_spreadsheet_values spreadsheet_id, range
    headers = response.values.shift
    # take off the first 2 - region and country
    headers.shift
    headers.shift
    puts "No data found." if response.values.empty?
    response.values.each do |row|
      region = row.shift
      country = row.shift
      row.each_with_index do |column, index| 
        if !column.nil? && !column.blank?
          #puts column + " implemented " + headers[index] + " in " + country
          create_project_entry(column, headers[index], country, "UNICEF Covid")  # org, product, country
        end
      end
    end
  end
end