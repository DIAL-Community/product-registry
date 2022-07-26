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
    first = create(:country, slug: 'first_country', name: 'First Country')
    second = create(:country, slug: 'second_country', name: 'Second Country')

    organization = create(:organization, name: 'Graph Organization', slug: 'graph_organization')
    expect_any_instance_of(Mutations::UpdateOrganizationCountry).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { countriesSlugs: [first.slug, second.slug], slug: organization.slug },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationCountry']['organization'])
        .to(eq({ "countries" => [{ "slug" => first.slug }, { "slug" => second.slug }], "slug" => organization.slug }))
    end
  end
end
