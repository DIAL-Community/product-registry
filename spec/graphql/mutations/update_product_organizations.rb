# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProductOrganizations, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProductOrganizations (
        $organizationsSlugs: [String!]!
        $slug: String!
        ) {
          updateProductOrganizations (
            organizationsSlugs: $organizationsSlugs
            slug: $slug
          ) {
            product {
              slug
              organizations {
                slug
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:product, name: 'Some Name', slug: 'some_name',
                     organizations: [create(:organization, slug: 'org_1', name: 'Org 1')])
    create(:organization, slug: 'org_2', name: 'Org 2')
    create(:organization, slug: 'org_3', name: 'Org 3')
    expect_any_instance_of(Mutations::UpdateProductOrganizations).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { organizationsSlugs: ['org_2', 'org_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProductOrganizations']['product'])
        .to(eq({ "slug" => "some_name", "organizations" => [{ "slug" => "org_2" }, { "slug" => "org_3" }] }))
      expect(result['data']['updateProductOrganizations']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:product, name: 'Some Name', slug: 'some_name',
                     organizations: [create(:organization, slug: 'org_1', name: 'Org 1')])
    create(:organization, slug: 'org_2', name: 'Org 2')
    create(:organization, slug: 'org_3', name: 'Org 3')

    result = execute_graphql(
      mutation,
      variables: { organizationsSlugs: ['org_2', 'org_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProductOrganizations']['product'])
        .to(eq(nil))
      expect(result['data']['updateProductOrganizations']['errors'])
        .to(eq(['Must be admin or product owner to update a product']))
    end
  end
end
