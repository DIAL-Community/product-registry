# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProjectProducts, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation($productsSlugs: [String!]!, $slug: String!) {
        updateProjectProducts(
          productsSlugs: $productsSlugs
          slug: $slug
        ) {
          project {
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
    create(:project, name: 'Some Name', slug: 'some_name',
                     products: [create(:product, slug: 'prod_1', name: 'Prod 1')])
    create(:product, slug: 'prod_2', name: 'Prod 2')
    create(:product, slug: 'prod_3', name: 'Prod 3')
    expect_any_instance_of(Mutations::UpdateProjectProducts).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { productsSlugs: ['prod_2', 'prod_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectProducts']['project'])
        .to(eq({ "slug" => "some_name", "products" => [{ "slug" => "prod_2" }, { "slug" => "prod_3" }] }))
      expect(result['data']['updateProjectProducts']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as product owner' do
    create(:project, name: 'Some Name', slug: 'some_name',
                     products: [create(:product, slug: 'prod_1', name: 'Prod 1')])
    create(:product, slug: 'prod_2', name: 'Prod 2')
    create(:product, slug: 'prod_3', name: 'Prod 3')
    expect_any_instance_of(Mutations::UpdateProjectProducts).to(receive(:product_owner_check).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { productsSlugs: ['prod_2', 'prod_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectProducts']['project'])
        .to(eq({ "slug" => "some_name", "products" => [{ "slug" => "prod_2" }, { "slug" => "prod_3" }] }))
      expect(result['data']['updateProjectProducts']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as product owner' do
    create(:project, name: 'Some Name', slug: 'some_name',
                     products: [create(:product, slug: 'prod_1', name: 'Prod 1')])
    create(:product, slug: 'prod_2', name: 'Prod 2')
    create(:product, slug: 'prod_3', name: 'Prod 3')
    expect_any_instance_of(Mutations::UpdateProjectProducts).to(receive(:product_owner_check).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { productsSlugs: ['prod_2', 'prod_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectProducts']['project'])
        .to(eq({ "slug" => "some_name", "products" => [{ "slug" => "prod_2" }, { "slug" => "prod_3" }] }))
      expect(result['data']['updateProjectProducts']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:project, name: 'Some Name', slug: 'some_name',
                     products: [create(:product, slug: 'prod_1', name: 'Prod 1')])
    create(:product, slug: 'prod_2', name: 'Prod 2')
    create(:product, slug: 'prod_3', name: 'Prod 3')

    result = execute_graphql(
      mutation,
      variables: { productsSlugs: ['prod_2', 'prod_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectProducts']['project'])
        .to(eq(nil))
      expect(result['data']['updateProjectProducts']['errors'])
        .to(eq(['Must have proper rights to update a project']))
    end
  end
end
