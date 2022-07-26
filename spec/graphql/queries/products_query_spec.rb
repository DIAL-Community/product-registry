# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::ProductsQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query SearchProducts(
        $first: Int,
        $after: String,
        $origins: [String!],
        $sectors: [String!],
        $countries: [String!],
        $organizations: [String!],
        $sdgs: [String!],
        $tags: [String!],
        $useCases: [String!],
        $workflows: [String!],
        $buildingBlocks: [String!],
        $productTypes: [String!],
        $endorsers: [String!],
        $productDeployable: Boolean,
        $withMaturity: Boolean,
        $search: String!
        ) {
        searchProducts(
          first: $first,
          after: $after,
          origins: $origins,
          sectors: $sectors,
          countries: $countries,
          organizations: $organizations,
          sdgs: $sdgs,
          tags: $tags,
          useCases: $useCases,
          workflows: $workflows,
          buildingBlocks: $buildingBlocks,
          productTypes: $productTypes,
          endorsers: $endorsers,
          productDeployable: $productDeployable,
          withMaturity: $withMaturity,
          search: $search
        ) {
          __typename
          totalCount
          pageInfo {
            endCursor
            startCursor
            hasPreviousPage
            hasNextPage
          }
          nodes {
            id
            name
            slug
            imageFile
            isLaunchable
            maturityScore
            productType
            tags
            endorsers {
              name
              slug
            }
            origins{
              name
              slug
            }
            buildingBlocks {
              slug
              name
              imageFile
            }
            sustainableDevelopmentGoals {
              slug
              name
              imageFile
            }
            productDescriptions {
              description
              locale
            }
            organizations {
              name
              isEndorser
            }
          }
        }
      }
    GQL
  end

  it 'is successful' do
    create(:product, name: 'Open Something Source', website: 'http://something.com')

    result = execute_graphql(
      query,
      variables: { search: 'Open' }
    )

    aggregate_failures do
      expect(result['data']['searchProducts']['totalCount']).to(eq(1))
      expect(result['data']['searchProducts']['nodes'].count).to(eq(1))
    end
  end

  it 'fails' do
    result = execute_graphql(
      query,
      variables: { search: 'Whatever' }
    )

    expect(result['data']['searchProducts']['totalCount']).to(eq(0))
  end
end

RSpec.describe(Queries::OwnedProductsQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query {
        ownedProducts {
          id
          slug
          name
        }
      }
    GQL
  end

  it 'pulls owned products for logged used' do
    first = create(:product, slug: 'first_product', name: 'First Product', id: 1)
    second = create(:product, slug: 'second_product', name: 'Second Product', id: 2)

    user = create(:user, email: 'user@gmail.com', user_products: [first.id, second.id])
    result = execute_graphql_as_user(user, query)

    aggregate_failures do
      expect(result['data']['ownedProducts'].count)
        .to(eq(2))
    end
  end

  it 'pulls empty array for not logged user' do
    result = execute_graphql(
      query
    )

    aggregate_failures do
      expect(result['data']['ownedProducts'].count)
        .to(eq(0))
    end
  end
end
