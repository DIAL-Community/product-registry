require 'swagger_helper'

RSpec.describe 'category_indicators', type: :request do

  path '/category_indicators' do
    post(summary: 'Create category indicator') do
      tags 'Category Indicator Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'category_indicator[rubric_category_id]', in: :formData,
                type: :integer, required: true, description: 'The id of the rubric category.'
      parameter name: 'category_indicator[name]', in: :formData,
                type: :string, required: true, description: 'The name of the indicator.'
      parameter name: 'category_indicator[weight]', in: :formData,
                type: :number, required: true, description: 'The weight of the indicator.'
      parameter name: 'category_indicator[indicator_type]', in: :formData,
      required: true, enum: ['scale', 'numeric', 'boolean'],
                description: 'The type of the indicator at source.'
      parameter name: 'category_indicator[source_indicator]', in: :formData,
                type: :string, required: true, description: 'The name of the indicator at source.'
      parameter name: 'category_indicator[data_source]', in: :formData,
                type: :string, required: true, description: 'The source of the indicator.'
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

  path '/category_indicators/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Id for the category indicator'

    patch(summary: 'Update category indicator') do
      tags 'Category Indicator Controller'

      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'category_indicator[rubric_category_id]', in: :formData,
                type: :integer, required: true, description: 'The id of the rubric category.'
      parameter name: 'category_indicator[name]', in: :formData,
                type: :string, required: true, description: 'The name of the indicator.'
      parameter name: 'category_indicator[weight]', in: :formData,
                type: :number, description: 'The weight of the indicator.'
      parameter name: 'category_indicator[indicator_type]', in: :formData,
                required: true, enum: ['scale', 'numeric', 'boolean'],
                description: 'The type of the indicator at source.'
      parameter name: 'category_indicator[source_indicator]', in: :formData,
                type: :string, description: 'The name of the indicator at source.'
      parameter name: 'category_indicator[data_source]', in: :formData,
                type: :string, description: 'The source of the indicator.'
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

    delete(summary: 'Delete a category indicator') do
      tags 'Category Indicator Controller'

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

  path '/maturity_rubrics/{maturity_rubric_id}/rubric_categories/{rubric_category_id}/category_indicators/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'maturity_rubric_id', in: :path, type: :string, description: 'Id for the maturity rubric'
    parameter name: 'rubric_category_id', in: :path, type: :string, description: 'Id for the rubric category'
    parameter name: 'id', in: :path, type: :string, description: 'Id for the category indicator'

    get(summary: 'Show category indicator') do
      tags 'Category Indicator Controller'

      response(200, description: 'successful') do
        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/category_indicator_duplicates' do
    get(summary: 'Find duplicates category indicator') do
      tags 'Category Indicator Controller'

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
