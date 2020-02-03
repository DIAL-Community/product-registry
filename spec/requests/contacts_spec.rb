require 'swagger_helper'

RSpec.describe 'contacts', type: :request do
  path '/contacts' do
    get('List all available contacts') do
      tags 'Contact Controller'

      produces 'application/json'
      consumes 'application/json'

      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow contact.'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('Create a new contact.') do
      tags 'Contact Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'contact[name]', in: :formData,
                type: :string, required: true, description: 'The name of the contact.'
      parameter name: 'contact[email]', in: :formData,
                type: :string, description: 'The email of the contact.'
      parameter name: 'contact[title]', in: :formData,
                type: :string, description: 'The title of the contact.'
      parameter name: 'reslug', in: :formData, enum: %w[true],
                type: :boolean, required: true, description: 'Should we regenerate slug for this object?'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual contact form.'

      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/contacts/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'The id of the contact'

    get('Find a contact by their id.') do
      tags 'Contact Controller'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('Update a contact by their id.') do
      tags 'Contact Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'contact[name]', in: :formData,
                type: :string, required: true, description: 'The name of the contact.'
      parameter name: 'contact[email]', in: :formData,
                type: :string, description: 'The email of the contact.'
      parameter name: 'contact[title]', in: :formData,
                type: :string, description: 'The title of the contact.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual contact form.'

      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete('Delete a contact by their contact id') do
      tags 'Contact Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual contact form.'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/contact_duplicates' do
    get('Find duplicates of contact.') do
      tags 'Contact Controller'

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
