require 'swagger_helper'

RSpec.describe 'organizations', type: :request do
  path '/organizations/count' do
    get(summary: 'Count all available organizations.') do
      tags 'Organization Controller'
      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/organizations' do
    get(summary: 'List all available organizations.') do
      tags 'Organization Controller'
      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post(summary: 'Create a new organization.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, required: true, description: 'The name of the organization.'
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

  path '/organizations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get(summary: 'Find an organization by their id.') do
      tags 'Organization Controller'
      response(200, description: 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch(summary: 'Update an organization by their id.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, description: 'The name of the organization.'
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

    delete(summary: 'Delete an organization by their id.') do
      tags 'Organization Controller'
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

  path '/locations/{location_id}/organizations' do
    # You'll want to customize the parameter types...
    parameter name: 'location_id', in: :path, type: :string, description: 'location_id'

    get(summary: 'List all organizations in a location.') do
      tags 'Organization Controller'
      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      response(200, description: 'successful') do
        let(:location_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post(summary: 'Add an organization to a location.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, required: true, description: 'The name of the organization.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, description: 'successful') do
        let(:location_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/locations/{location_id}/organizations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'location_id', in: :path, type: :string, description: 'location_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get(summary: 'Find an organization for a location by their id.') do
      tags 'Organization Controller'
      response(200, description: 'successful') do
        let(:location_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch(summary: 'Update an organization for a location by their id.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, description: 'The name of the organization.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, description: 'successful') do
        let(:location_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete(summary: 'Remove an organization for a location by their id.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, description: 'successful') do
        let(:location_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/sectors/{sector_id}/organizations' do
    # You'll want to customize the parameter types...
    parameter name: 'sector_id', in: :path, type: :string, description: 'sector_id'

    get(summary: 'List organizations for a sector.') do
      tags 'Organization Controller'
      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      response(200, description: 'successful') do
        let(:sector_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post(summary: 'Add an organization to a sector.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, required: true, description: 'The name of the workflow.'
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

  path '/sectors/{sector_id}/organizations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'sector_id', in: :path, type: :string, description: 'sector_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get(summary: 'Find an organization for a sector by their id.') do
      tags 'Organization Controller'
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

    patch(summary: 'Update an organization for a sector by their id.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, description: 'The name of the workflow.'
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

    delete(summary: 'Delete an organization for a sector by their id.') do
      tags 'Organization Controller'
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

  path '/contacts/{contact_id}/organizations' do
    # You'll want to customize the parameter types...
    parameter name: 'contact_id', in: :path, type: :string, description: 'contact_id'

    get(summary: 'List all organizations for a contact.') do
      tags 'Organization Controller'
      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      response(200, description: 'successful') do
        let(:contact_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post(summary: 'Add an organization to a contact.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, required: true, description: 'The name of the workflow.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, description: 'successful') do
        let(:contact_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/contacts/{contact_id}/organizations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'contact_id', in: :path, type: :string, description: 'contact_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get(summary: 'Find an organization for a contact by their id.') do
      tags 'Organization Controller'
      response(200, description: 'successful') do
        let(:contact_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch(summary: 'Update an organization for a contact by their id.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'organization[name]', in: :formData,
                type: :string, description: 'The name of the workflow.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, description: 'successful') do
        let(:contact_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete(summary: 'Delete an organization for a contact by their id.') do
      tags 'Organization Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual form.'
      response(200, description: 'successful') do
        let(:contact_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/agg_capabilities' do
    get(summary: 'agg_capabilities organization') do
      tags 'Organization Controller'
      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/agg_services' do
    get(summary: 'agg_services organization') do
      tags 'Organization Controller'
      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/service_capabilities' do
    get(summary: 'service_capabilities organization') do
      tags 'Organization Controller'
      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/update_capability' do
    get(summary: 'update_capability organization') do
      tags 'Organization Controller'
      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/organization_duplicates' do
    get(summary: 'Find duplicate organizations.') do
      tags 'Organization Controller'

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
