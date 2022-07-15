# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateBuildingBlockProducts, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateBuildingBlockProducts (
        $productsSlugs: [String!]!
        $slug: String!
        $mappingStatus: String!
        ) {
          updateBuildingBlockProducts (
            productsSlugs: $productsSlugs
            slug: $slug
            mappingStatus: $mappingStatus
          ) {
            buildingBlock {
              slug
              products {
                slug
                buildingBlocksMappingStatus
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:building_block, name: 'Some Name', slug: 'some_name',
                      products: [create(:product, slug: 'prod_1', name: 'Prod 1')])
    create(:product, slug: 'prod_2', name: 'Prod 2')
    create(:product, slug: 'prod_3', name: 'Prod 3')
    expect_any_instance_of(Mutations::UpdateBuildingBlockProducts).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { productsSlugs: ['prod_2', 'prod_3'], slug: 'some_name', mappingStatus: 'VALIDATED' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockProducts']['buildingBlock'])
        .to(eq({ "slug" => "some_name",
                 "products" => [{ "slug" => "prod_2", "buildingBlocksMappingStatus" => "VALIDATED" },
                                { "slug" => "prod_3", "buildingBlocksMappingStatus" => "VALIDATED" }] }))
      expect(result['data']['updateBuildingBlockProducts']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    create(:building_block, name: 'Some Name', slug: 'some_name',
                      products: [create(:product, slug: 'prod_1', name: 'Prod 1')])
    create(:product, slug: 'prod_2', name: 'Prod 2')
    create(:product, slug: 'prod_3', name: 'Prod 3')
    expect_any_instance_of(Mutations::UpdateBuildingBlockProducts).to(receive(:a_content_editor).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { productsSlugs: ['prod_2', 'prod_3'], slug: 'some_name', mappingStatus: 'BETA' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockProducts']['buildingBlock'])
        .to(eq({ "slug" => "some_name",
                 "products" => [{ "slug" => "prod_2", "buildingBlocksMappingStatus" => "BETA" },
                                { "slug" => "prod_3", "buildingBlocksMappingStatus" => "BETA" }] }))
      expect(result['data']['updateBuildingBlockProducts']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user has not proper rights' do
    expect_any_instance_of(Mutations::UpdateBuildingBlockProducts).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::UpdateBuildingBlockProducts).to(receive(:a_content_editor).and_return(false))

    create(:building_block, name: 'Some Name', slug: 'some_name',
                     products: [create(:product, slug: 'prod_1', name: 'Prod 1')])
    create(:product, slug: 'prod_2', name: 'Prod 2')
    create(:product, slug: 'prod_3', name: 'Prod 3')

    result = execute_graphql(
      mutation,
      variables: { productsSlugs: ['prod_2', 'prod_3'], slug: 'some_name', mappingStatus: 'BETA' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockProducts']['buildingBlock'])
        .to(eq(nil))
      expect(result['data']['updateBuildingBlockProducts']['errors'])
        .to(eq(['Must be admin or content editor to update building block']))
    end
  end

  it 'is fails - user is not logged in' do
    create(:building_block, name: 'Some Name', slug: 'some_name',
                     products: [create(:product, slug: 'prod_1', name: 'Prod 1')])
    create(:product, slug: 'prod_2', name: 'Prod 2')
    create(:product, slug: 'prod_3', name: 'Prod 3')

    result = execute_graphql(
      mutation,
      variables: { productsSlugs: ['prod_2', 'prod_3'], slug: 'some_name', mappingStatus: 'BETA' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockProducts']['buildingBlock'])
        .to(eq(nil))
      expect(result['data']['updateBuildingBlockProducts']['errors'])
        .to(eq(['Must be admin or content editor to update building block']))
    end
  end
end
