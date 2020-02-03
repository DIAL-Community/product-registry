require 'swagger_helper'

RSpec.describe 'audits', type: :request do
  path '/audits' do
    get('List of all available audits for an object.') do
      tags 'Audit Controller'

      produces 'application/json'
      consumes 'application/json'

      parameter name: :type, in: :query, schema: { type: :string },
                enum: %w[Organization Product],
                description: 'Select one of the available object type.'

      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end
end
