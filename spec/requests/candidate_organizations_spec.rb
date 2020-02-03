require 'swagger_helper'

RSpec.describe 'candidate_organizations', type: :request do
  path '/candidate_organizations/{id}/reject' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'The id of the candidate organization.'
    parameter name: :authenticity_token, in: :formData,
              type: :string, required: true, description: 'Token from an actual candidate organization form.'

    post('Reject a candidate organization.') do
      tags 'Candidate Organization Controller'

      consumes 'multipart/form-data'
      produces 'application/json'
      response(201, 'Success') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/candidate_organizations/{id}/approve' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'The id of the candidate organization.'
    parameter name: :authenticity_token, in: :formData,
              type: :string, required: true, description: 'Token from an actual candidate organization form.'

    post('Approve a candidate organization.') do
      tags 'Candidate Organization Controller'

      consumes 'multipart/form-data'
      produces 'application/json'
      response(201, 'Success') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/candidate_organizations' do
    get('Get the list of all available candidate organization.') do
      tags 'Candidate Organization Controller'

      produces 'application/json'
      consumes 'application/json'

      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow candidate.'

      response(200, 'Success') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('Propose a new candidate organization.') do
      tags 'Candidate Organization Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'candidate_organization[name]', in: :formData,
                type: :string, required: true, description: 'The name of the candidate organization.'
      parameter name: 'reslug', in: :formData, enum: %w[true],
                type: :boolean, required: true, description: 'Should we regenerate slug for this object.'
      parameter name: 'contact[name]', in: :formData,
                type: :string, required: true, description: 'The name of the contact for the organization.'
      parameter name: 'contact[email]', in: :formData,
                type: :string, description: 'The email of the contact for the organization'
      parameter name: 'contact[title]', in: :formData,
                type: :string, description: 'The title of the contact for the organization.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual candidate organization form.'
      parameter name: 'g-recaptcha-response', in: :formData, type: :string, required: true,
                description: 'Response token from recaptcha. Generate this by clicking the recaptcha and see the network op.'

      response(201, 'Success') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/candidate_organizations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'The id of the candidate organization.'

    get('Find a single candidate organization by their id.') do
      tags 'Candidate Organization Controller'

      produces 'application/json'
      consumes 'application/json'
      response(200, 'Success') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('Update a candidate organization by their id.') do
      tags 'Candidate Organization Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'candidate_organization[name]', in: :formData,
                type: :string, required: true, description: 'The name of the candidate organization.'
      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual candidate organization form.'
      parameter name: 'g-recaptcha-response', in: :formData, type: :string, required: true,
                description: 'Response token from recaptcha. Generate this by clicking the recaptcha and see the network op.'
      response(200, 'Success') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete('Delete candidate organization by their id.') do
      tags 'Candidate Organization Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :authenticity_token, in: :formData,
                type: :string, required: true, description: 'Token from an actual candidate organization form.'
      response(204, 'Success') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/candidate_organization_duplicates' do
    get('Find duplicates of candidate organization.') do
      tags 'Candidate Organization Controller'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :current, in: :query, schema: { type: :string }
      parameter name: :original, in: :query, required: true, schema: { type: :string }
      response(200, 'Success') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end
end
