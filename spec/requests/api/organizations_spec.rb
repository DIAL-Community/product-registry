# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe('Organizations V1 API', type: :request) do
  path '/api/v1/organizations/{slug}' do
    get 'Retrieves an organization.' do
      tags 'Organizations'
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

  path '/api/v1/organizations' do
    get 'Search for organizations.' do
      tags 'Organizations'
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

    post 'Search for organizations.' do
      tags 'Organizations'

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
          sectors: {
            type: :array,
            items: {
              type: :string
            }
          },
          endorsing_years: {
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
