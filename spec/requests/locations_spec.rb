require 'swagger_helper'

RSpec.describe 'locations', type: :request do
  path '/locations' do
    get(summary: 'List all available locations.') do
      tags 'Location Controller'

      produces 'application/json'
      consumes 'application/json'

      parameter name: :search, in: :query, schema: { type: :string },
                description: 'Search term to narrow locations.'
      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post(summary: 'Create a new location.') do
      tags 'Location Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'location[name]', in: :formData,
                type: :string, required: true, description: 'The name of the location.'
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

  path '/locations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'The id of the location.'

    get(summary: 'Find a location by their id.') do
      tags 'Location Controller'
      response(200, description: 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch(summary: 'Update a location by their id.') do
      tags 'Location Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'location[name]', in: :formData,
                type: :string, required: true, description: 'The name of the location.'
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

    delete(summary: 'Delete a location by their id.') do
      tags 'Location Controller'
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

  path '/location_duplicates' do
    get(summary: 'Find duplicates of locations.') do
      tags 'Location Controller'

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
