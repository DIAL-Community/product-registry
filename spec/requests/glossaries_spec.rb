require 'swagger_helper'

RSpec.describe 'glossaries', type: :request do
  path '/glossaries' do
    get(summary: 'List available terms from the glossary.') do
      tags 'Glossary Controller'

      produces 'application/json'
      consumes 'application/json'

      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow terms.'

      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post(summary: 'Create new term in the glossary.') do
      tags 'Glossary Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'glossary[name]', in: :formData,
                type: :string, required: true, description: 'The term of the glossary.'
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

  path '/glossaries/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'The id of the term.'

    get(summary: 'Find a term from glossary with their id.') do
      tags 'Glossary Controller'
      response(200, description: 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch(summary: 'Update term in the glossary using their id.') do
      tags 'Glossary Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'glossary[name]', in: :formData,
                type: :string, required: true, description: 'The term of the glossary.'
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

    delete(summary: 'Delete a term from glossary using their id.') do
      tags 'Glossary Controller'
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

  path '/glossary_duplicates' do
    get(summary: 'Find duplicate glossary terms.') do
      tags 'Glossary Controller'

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
