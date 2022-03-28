# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe('Projects V1 API', type: :request) do
  path '/api/v1/projects/{slug}' do
    get 'Retrieves a project.' do
      tags 'Projects'
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

  path '/api/v1/projects' do
    get 'Search for projects.' do
      tags 'Projects'
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

    post 'Search for projects.' do
      tags 'Projects'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      parameter name: :page, in: :query, schema: { type: :integer }, description: 'Page to narrow results.'
      parameter name: :request_body, in: :body, schema: {
        type: :object,
        properties: {
          countries: {
            type: :array,
            items: {
              type: :string
            }
          },
          organizations: {
            type: :array,
            items: {
              type: :string
            }
          },
          origins: {
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
          },
          sdgs: {
            type: :array,
            items: {
              type: :string
            }
          },
          sectors: {
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
