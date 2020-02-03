require 'swagger_helper'

RSpec.describe 'sustainable_development_goals', type: :request do
  path '/sustainable_development_goals/count' do
    get('Count available sustainable development goal.') do
      tags 'SDG Controller'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/sustainable_development_goals' do
    get('List all available sustainable development goals') do
      tags 'SDG Controller'
      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/sustainable_development_goals/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'SDG id.'

    get('Find a sustainable development goal by their id.') do
      tags 'SDG Controller'
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
