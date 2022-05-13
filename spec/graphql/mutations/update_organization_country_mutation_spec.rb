# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOrganizationCountry, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation($countriesSlugs: [String!]!, $slug: String!) {
        updateOrganizationCountry(
          countriesSlugs: $countriesSlugs
          slug: $slug
        ) {
          organization {
            slug
            countries {
              slug
            }
          }
          errors
        }
      }
    GQL
  end

  it 'is successful' do
    create(:country, slug: 'c3', name: 'country3', code: 'cc3', code_longer: 'ccl3', latitude: 35.5, longitude: 41.1)
    create(:country, slug: 'c2', name: 'country2', code: 'cc2', code_longer: 'ccl2', latitude: 35.5, longitude: 41.1)
    create(:country, slug: 'c1', name: 'country1', code: 'cc1', code_longer: 'ccl1', latitude: 35.5, longitude: 41.1)

    result = execute_graphql(
      mutation,
      variables: { countriesSlugs: ['c1', 'c2'], slug: 'o1' },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationCountry']['organization'])
        .to(eq({ "countries" => [{ "slug" => "c1" }, { "slug" => "c2" }], "slug" => "o1" }))
    end
  end
end
