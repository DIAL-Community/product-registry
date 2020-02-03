require 'swagger_helper'

RSpec.describe 'product_suites', type: :request do
  path '/product_suites' do
    get('List all available product suites.') do
      tags 'Product Suite Controller'
      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('Create a new product suite.') do
      tags 'Product Suite Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'product_suite[name]', in: :formData,
                type: :string, description: 'The name of the product suite.'
      parameter name: 'product_suite[description]', in: :formData,
                type: :string, description: 'The description of the product suite.'
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

  path '/product_suites/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'Product suite id.'

    get('Find a product suite by their id.') do
      tags 'Product Suite Controller'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('Update a product suite by their id.') do
      tags 'Product Suite Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'product_suite[name]', in: :formData,
                type: :string, description: 'The name of the product suite.'
      parameter name: 'product_suite[description]', in: :formData,
                type: :string, description: 'The description of the product suite.'
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

    delete('Delete a product suite by their id.') do
      tags 'Product Suite Controller'
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

  path '/product_suite_duplicates' do
    get('Find duplicate product suites') do
      tags 'Product Suite Controller'

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
