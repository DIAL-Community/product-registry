require 'swagger_helper'

RSpec.describe 'maturity_rubrics', type: :request do

  path '/maturity_rubrics' do
    get(summary: 'List all maturity rubric') do
      tags 'Maturity Rubric Controller'
      parameter name: :search, in: :query, schema: { type: :string }, description: 'Search term to narrow results.'
      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
    post(summary: 'Create maturity rubric') do
      tags 'Maturity Rubric Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'maturity_rubric[name]', in: :formData,
                type: :string, required: true, description: 'The name of the maturity.'
      parameter name: 'reslug', in: :formData, enum: %w[true],
                type: :boolean, required: true, description: 'Should we regenerate slug for this object?'
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

  path '/maturity_rubrics/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'The maturity rubric id.'

    get(summary: 'Show maturity rubric') do
      tags 'Maturity Rubric Controller'
      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch(summary: 'Update maturity rubric') do
      tags 'Maturity Rubric Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'maturity_rubric[name]', in: :formData,
                type: :string, required: true, description: 'The name of the maturity.'
      parameter name: 'reslug', in: :formData, enum: %w[true],
                type: :boolean, required: true, description: 'Should we regenerate slug for this object?'
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

    delete(summary: 'Delete maturity rubric') do
      tags 'Maturity Rubric Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

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

  path '/maturity_rubric_duplicates' do
    get(summary: 'Find duplicates maturity rubric') do
      tags 'Maturity Rubric Controller'

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
