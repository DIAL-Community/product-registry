require 'swagger_helper'

RSpec.describe 'workflows', type: :request do
  path '/workflows/count' do
    get('Count available workflows.') do
      tags 'Workflow Controller'
      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/workflows' do
    get('List all available workflows.') do
      tags 'Workflow Controller'

      produces 'application/json'
      consumes 'application/json'

      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow workflows.'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('Create a new workflow.') do
      tags 'Workflow Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'workflow[name]', in: :formData,
                type: :string, required: true, description: 'The name of the workflow.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/workflows/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'The id of the workflow.'

    get('Find a workflow by their id.') do
      tags 'Workflow Controller'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('Update a workflow by their id.') do
      tags 'Workflow Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'workflow[name]', in: :formData,
                type: :string, required: true, description: 'The name of the workflow.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete('Delete a workflow by their id.') do
      tags 'Workflow Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/workflow_duplicates' do
    get('Find duplicate workflows.') do
      tags 'Workflow Controller'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :current, in: :query, schema: { type: :string }
      parameter name: :original, in: :query, required: true, schema: { type: :string }
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end
end
