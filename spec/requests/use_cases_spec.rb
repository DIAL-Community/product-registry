require 'swagger_helper'

RSpec.describe 'use_cases', type: :request do
  path '/use_cases/count' do
    get(summary: 'Count available use cases.') do
      tags 'Use Case Controller'
      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/use_cases' do
    get(summary: 'List all available use cases.') do
      tags 'Use Case Controller'

      produces 'application/json'
      consumes 'application/json'

      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow use case.'
      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post(summary: 'Create a new use case.') do
      tags 'Use Case Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'use_case[name]', in: :formData,
                type: :string, required: true, description: 'The name of the use case.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/use_cases/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'Use case id.'

    get(summary: 'Find a use case by their id.') do
      tags 'Use Case Controller'
      response(200, description: 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch(summary: 'Update a use case by their id.') do
      tags 'Use Case Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'use_case[name]', in: :formData,
                type: :string, required: true, description: 'The name of the use case.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, description: 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete(summary: 'Delete a use case by their id.') do
      tags 'Use Case Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, description: 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/sectors/{sector_id}/use_cases' do
    # You'll want to customize the parameter types...
    parameter name: 'sector_id', in: :path, type: :string, description: 'sector_id'

    get(summary: 'List all use cases associated with a sector.') do
      tags 'Use Case Controller'

      produces 'application/json'
      consumes 'application/json'

      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow use cases.'
      response(200, description: 'successful') do
        let(:sector_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post(summary: 'Create a new use case for a sector.') do
      tags 'Use Case Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'use_case[name]', in: :formData,
                type: :string, required: true, description: 'The name of the use case.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, description: 'successful') do
        let(:sector_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/sectors/{sector_id}/use_cases/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'sector_id', in: :path, type: :string, description: 'Sector id.'
    parameter name: 'id', in: :path, type: :string, description: 'Use case id.'

    get(summary: 'Find a use case for a sector.') do
      tags 'Use Case Controller'
      response(200, description: 'successful') do
        let(:sector_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch(summary: 'Update a use case associated with a sector.') do
      tags 'Use Case Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'use_case[name]', in: :formData,
                type: :string, required: true, description: 'The name of the use case.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, description: 'successful') do
        let(:sector_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete(summary: 'Remove a use case from a sector.') do
      tags 'Use Case Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, description: 'successful') do
        let(:sector_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/use_case_duplicates' do
    get(summary: 'Find duplicate use cases.') do
      tags 'Use Case Controller'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :current, in: :query, schema: { type: :string }
      parameter name: :original, in: :query, required: true, schema: { type: :string }
      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end
end
