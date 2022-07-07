# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateUseCaseStepProducts, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateUseCaseStepProducts (
        $productsSlugs: [String!]!
        $slug: String!
        ) {
          updateUseCaseStepProducts (
            productsSlugs: $productsSlugs
            slug: $slug
          ) {
            useCaseStep {
              slug
              products {
                slug
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:use_case_step, name: 'Some Name', slug: 'some_name',
                      products: [create(:product, slug: 'prod_1', name: 'Prod 1')])
    create(:product, slug: 'prod_2', name: 'Prod 2')
    create(:product, slug: 'prod_3', name: 'Prod 3')
    expect_any_instance_of(Mutations::UpdateUseCaseStepProducts).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { productsSlugs: ['prod_2', 'prod_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepProducts']['useCaseStep'])
        .to(eq({ "slug" => "some_name", "products" => [{ "slug" => "prod_2" }, { "slug" => "prod_3" }] }))
      expect(result['data']['updateUseCaseStepProducts']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    create(:use_case_step, name: 'Some Name', slug: 'some_name',
                      products: [create(:product, slug: 'prod_1', name: 'Prod 1')])
    create(:product, slug: 'prod_2', name: 'Prod 2')
    create(:product, slug: 'prod_3', name: 'Prod 3')
    expect_any_instance_of(Mutations::UpdateUseCaseStepProducts).to(receive(:a_content_editor).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { productsSlugs: ['prod_2', 'prod_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepProducts']['useCaseStep'])
        .to(eq({ "slug" => "some_name", "products" => [{ "slug" => "prod_2" }, { "slug" => "prod_3" }] }))
      expect(result['data']['updateUseCaseStepProducts']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user has not proper rights' do
    expect_any_instance_of(Mutations::UpdateUseCaseStepProducts).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::UpdateUseCaseStepProducts).to(receive(:a_content_editor).and_return(false))

    create(:use_case_step, name: 'Some Name', slug: 'some_name',
                     products: [create(:product, slug: 'prod_1', name: 'Prod 1')])
    create(:product, slug: 'prod_2', name: 'Prod 2')
    create(:product, slug: 'prod_3', name: 'Prod 3')

    result = execute_graphql(
      mutation,
      variables: { productsSlugs: ['prod_2', 'prod_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepProducts']['useCaseStep'])
        .to(eq(nil))
      expect(result['data']['updateUseCaseStepProducts']['errors'])
        .to(eq(['Must be admin or content editor to update use case step']))
    end
  end

  it 'is fails - user is not logged in' do
    create(:use_case_step, name: 'Some Name', slug: 'some_name',
                     products: [create(:product, slug: 'prod_1', name: 'Prod 1')])
    create(:product, slug: 'prod_2', name: 'Prod 2')
    create(:product, slug: 'prod_3', name: 'Prod 3')

    result = execute_graphql(
      mutation,
      variables: { productsSlugs: ['prod_2', 'prod_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepProducts']['useCaseStep'])
        .to(eq(nil))
      expect(result['data']['updateUseCaseStepProducts']['errors'])
        .to(eq(['Must be admin or content editor to update use case step']))
    end
  end
end
