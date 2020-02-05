require 'swagger_helper'

RSpec.describe 'settings', type: :request do
  path '/settings' do
    get('List all available settings.') do
      tags 'Settings Controller'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/settings/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'Setting id.'

    get('Find a setting by their id.') do
      tags 'Settings Controller'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('Update a setting by their id.') do
      tags 'Settings Controller'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'setting[name]', in: :formData,
                type: :string, description: 'Name of the setting.'
      parameter name: 'setting[description]', in: :formData,
                type: :string, description: 'Description of the setting.'
      parameter name: 'setting[value]', in: :formData,
                type: :string, description: 'Value of the setting.'
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
