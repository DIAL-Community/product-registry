require 'swagger_helper'

RSpec.describe 'rubric_categories', type: :request do

  path '/rubric_categories' do
    post(summary: 'Create rubric category') do
      tags 'Rubric Category Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'rubric_category[maturity_rubric_id]', in: :formData,
                type: :integer, required: true, description: 'The id of the rubric.'
      parameter name: 'rubric_category[name]', in: :formData,
                type: :string, required: true, description: 'The name of the category.'
      parameter name: 'rubric_category[weight]', in: :formData,
                type: :number, required: true, description: 'The weight of the category.'
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

  path '/rubric_categories/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'The rubric category id.'

    patch(summary: 'Update rubric category') do
      tags 'Rubric Category Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'rubric_category[maturity_rubric_id]', in: :formData,
                type: :integer, required: true, description: 'The id of the rubric.'
      parameter name: 'rubric_category[name]', in: :formData,
                type: :string, required: true, description: 'The name of the category.'
      parameter name: 'rubric_category[weight]', in: :formData,
                type: :number, description: 'The weight of the category.'
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

    delete(summary: 'Delete rubric category') do
      tags 'Rubric Category Controller'

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

  path '/maturity_rubrics/{maturity_rubric_id}/rubric_categories/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'maturity_rubric_id', in: :path, type: :string,
              description: 'The maturity rubric id.'
    parameter name: 'id', in: :path, type: :string, description: 'The rubric category id.'

    get(summary: 'Show rubric category') do
      tags 'Rubric Category Controller'

      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/rubric_category_duplicates' do
    get(summary: 'Find duplicates rubric category') do
      tags 'Rubric Category Controller'

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
