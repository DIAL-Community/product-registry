require 'swagger_helper'

RSpec.describe('Tags V1 API', type: :request) do
  path '/api/v1/tags/{slug}' do
    get 'Retrieves a tag.' do
      tags 'Tags'
      produces 'application/json'

      parameter(name: :slug, in: :path, type: :string)
      response(200, description: 'Success.') do
        let(:slug) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end

      response(404, description: 'Error: Not Found.') do
        let(:slug) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/tags' do
    get 'Search for tags.' do
      tags 'Tags'
      produces 'application/json'

      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      parameter name: :page, in: :query, schema: { type: :integer }, description: 'Page to narrow results.'

      response(200, description: 'Success.') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end
end
