require 'swagger_helper'

RSpec.describe 'operator_services', type: :request do
  path '/operator_services' do
    get(summary: 'List available operator services.') do
      tags 'Operator Service Controller'
      parameter name: :search, in: :query, schema: { type: :string },
                description: 'Search term to narrow results.'
      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post(summary: 'Create a new operator service.') do
      tags 'Operator Service Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'operator_service[name]', in: :formData,
                type: :string, required: true, description: 'The name of the operator service.'
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

  path '/operator_services/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get(summary: 'Find an operator service by their id.') do
      tags 'Operator Service Controller'
      response(200, description: 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch(summary: 'Update an operator service by their id.') do
      tags 'Operator Service Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'operator_service[name]', in: :formData,
                type: :string, description: 'The name of the operator service.'
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

    delete(summary: 'Delete an operator service by their id.') do
      tags 'Operator Service Controller'
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
end
