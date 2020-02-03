require 'swagger_helper'

RSpec.describe 'sdg_targets', type: :request do
  path '/sdg_targets' do
    get('List all available SDG targets.') do
      tags 'SDG Target Controller'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/sdg_targets/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'SDG Target id.'

    get('Find an SDG target by their id.') do
      tags 'SDG Target Controller'
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
