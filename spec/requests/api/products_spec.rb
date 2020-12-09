require 'swagger_helper'

RSpec.describe('Products V1 API', type: :request) do
  path '/api/v1/products/{slug}' do
    get 'Retrieves a product.' do
      tags 'Products'
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

  path '/api/v1/products' do
    get 'Search for products.' do
      tags 'Products'
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

    post 'Search for products.' do
      tags 'Products'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      parameter name: :page, in: :query, schema: { type: :integer }, description: 'Page to narrow results.'
      parameter name: :request_body, in: :body, schema: {
        type: :object,
        properties: {
          sdgs: {
            type: :array,
            description: 'SDG',
            items: {
              type: :string
            }
          },
          use_cases: {
            type: :array,
            items: {
              type: :string
            }
          },
          workflows: {
            type: :array,
            items: {
              type: :string
            }
          },
          building_blocks: {
            type: :array,
            items: {
              type: :string
            }
          },
          products: {
            type: :array,
            items: {
              type: :string
            }
          }
        }
      }, description: 'JSON to narrow results.'

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
