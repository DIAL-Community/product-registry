require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/admin/users' do
    get('List all available users.') do
      tags 'User Controller'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('Create a new user.') do
      tags 'User Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'user[email]', in: :formData,
                type: :string, required: true, description: 'Email address of the user.'
      parameter name: 'user[password]', in: :formData,
                type: :string, required: true, description: 'Password of the user.'
      parameter name: 'user[password_confirmation]', in: :formData,
                type: :string, required: true, description: 'Password confirmation of the user.'
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

  path '/admin/users/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'The id of the user.'

    get('Find a user by their id.') do
      tags 'User Controller'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('Update a user by their id.') do
      tags 'User Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'user[email]', in: :formData,
                type: :string, description: 'Email address of the user.'
      parameter name: 'user[password]', in: :formData,
                type: :string, description: 'Password of the user.'
      parameter name: 'user[password_confirmation]', in: :formData,
                type: :string, description: 'Password confirmation of the user.'
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

    delete('Delete a user by their id.') do
      tags 'User Controller'
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
end
