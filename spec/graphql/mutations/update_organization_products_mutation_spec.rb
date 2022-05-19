# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOrganizationProducts, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation($productsSlugs: [String!]!, $slug: String!) {
        updateOrganizationProducts(
          productsSlugs: $productsSlugs
          slug: $slug
        ) {
          organization {
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

  it 'is successful' do
    country1 = create(:country, slug: 'c1', name: 'country1', code: 'cc1', code_longer: 'ccl1', latitude: 35.5,
    longitude: 41.1)

    product3 = create(:product, slug: 'p3', name: 'product3')

    create(:product, slug: 'p2', name: 'product2')
    create(:product, slug: 'p1', name: 'product1')

    organization = create(:organization, slug: 'org1', name: 'organization1', products: [product3],
      countries: [country1])

    result = execute_graphql(
      mutation,
      variables: { productsSlugs: ['p1', 'p2'], slug: organization.slug },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationProducts']['organization'])
        .to(eq({ "products" => [{ "slug" => "p1" }, { "slug" => "p2" }], "slug" => "org1" }))
    end
  end
end
