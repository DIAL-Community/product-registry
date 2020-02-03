require 'swagger_helper'

RSpec.describe 'building_blocks', type: :request do
  path '/building_blocks/count' do
    get('Count number of current building blocks.') do
      tags 'Building Block Controller'
      response(200, 'Success') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json': JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/building_blocks' do
    get('List of all existing building blocks in the database.') do
      tags 'Building Block Controller'

      produces 'application/json'
      consumes 'application/json'

      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow building blocks.'

      response(200, 'Success') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json': JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/building_blocks' do
    post('Create a new building block.') do
      tags 'Building Block Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'building_block[name]', in: :formData,
                type: :string, required: true, description: 'The name of the building block.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual building block form.'

      response(200, 'Success') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json': JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
      response(401, 'Unauthorized') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json': JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/building_blocks/{id}' do
    # You'll want to customize the parameter types...

    get('Find a single building block by their id.') do
      tags 'Building Block Controller'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, required: true, schema: { type: :string },
                description: 'The id of the building block.'

      response(200, 'Success') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json': JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('Update a single building block object.') do
      tags 'Building Block Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :id, in: :path, required: true, schema: { type: :string },
                description: 'The id of the building block.'
      parameter name: 'building_block[name]', in: :formData,
                type: :string, required: true, description: 'The name of the building block.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual building block form.'

      response(200, 'Success') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json': JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete('Delete a single building block object.') do
      tags 'Building Block Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :id, in: :path, required: true, schema: { type: :string },
                description: 'The id of the building block.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual building block form.'

      response(204, 'Success') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json': JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/building_block_duplicates' do
    get('Find duplicates of building block object.') do
      tags 'Building Block Controller'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :current, in: :query, schema: { type: :string }
      parameter name: :original, in: :query, required: true, schema: { type: :string }

      response(200, 'Success') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json': JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end
end
