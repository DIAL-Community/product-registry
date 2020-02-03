require 'swagger_helper'

RSpec.describe 'organizations', type: :request do
  path '/organizations/count' do
    get('Count all available organizations.') do
      tags 'Organization Controller'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/organizations' do
    get('List all available organizations.') do
      tags 'Organization Controller'
      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('Create a new organization.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, required: true, description: 'The name of the organization.'
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

  path '/organizations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('Find an organization by their id.') do
      tags 'Organization Controller'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('Update an organization by their id.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, description: 'The name of the organization.'
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

    delete('Delete an organization by their id.') do
      tags 'Organization Controller'
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

  path '/locations/{location_id}/organizations' do
    # You'll want to customize the parameter types...
    parameter name: 'location_id', in: :path, type: :string, description: 'location_id'

    get('List all organizations in a location.') do
      tags 'Organization Controller'
      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      response(200, 'successful') do
        let(:location_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('Add an organization to a location.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, required: true, description: 'The name of the organization.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, 'successful') do
        let(:location_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/locations/{location_id}/organizations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'location_id', in: :path, type: :string, description: 'location_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('Find an organization for a location by their id.') do
      tags 'Organization Controller'
      response(200, 'successful') do
        let(:location_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('Update an organization for a location by their id.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, description: 'The name of the organization.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, 'successful') do
        let(:location_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete('Remove an organization for a location by their id.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, 'successful') do
        let(:location_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/sectors/{sector_id}/organizations' do
    # You'll want to customize the parameter types...
    parameter name: 'sector_id', in: :path, type: :string, description: 'sector_id'

    get('List organizations for a sector.') do
      tags 'Organization Controller'
      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      response(200, 'successful') do
        let(:sector_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('Add an organization to a sector.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, required: true, description: 'The name of the workflow.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, 'successful') do
        let(:sector_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/sectors/{sector_id}/organizations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'sector_id', in: :path, type: :string, description: 'sector_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('Find an organization for a sector by their id.') do
      tags 'Organization Controller'
      response(200, 'successful') do
        let(:sector_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('Update an organization for a sector by their id.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, description: 'The name of the workflow.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, 'successful') do
        let(:sector_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete('Delete an organization for a sector by their id.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, 'successful') do
        let(:sector_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/contacts/{contact_id}/organizations' do
    # You'll want to customize the parameter types...
    parameter name: 'contact_id', in: :path, type: :string, description: 'contact_id'

    get('List all organizations for a contact.') do
      tags 'Organization Controller'
      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      response(200, 'successful') do
        let(:contact_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('Add an organization to a contact.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, required: true, description: 'The name of the workflow.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, 'successful') do
        let(:contact_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/contacts/{contact_id}/organizations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'contact_id', in: :path, type: :string, description: 'contact_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('Find an organization for a contact by their id.') do
      tags 'Organization Controller'
      response(200, 'successful') do
        let(:contact_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('Update an organization for a contact by their id.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, description: 'The name of the workflow.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, 'successful') do
        let(:contact_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete('Delete an organization for a contact by their id.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, 'successful') do
        let(:contact_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/agg_capabilities' do
    get('agg_capabilities organization') do
      tags 'Organization Controller'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/agg_services' do
    get('agg_services organization') do
      tags 'Organization Controller'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/service_capabilities' do
    get('service_capabilities organization') do
      tags 'Organization Controller'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/update_capability' do
    get('update_capability organization') do
      tags 'Organization Controller'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/organization_duplicates' do
    get('Find duplicate organizations.') do
      tags 'Organization Controller'

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
