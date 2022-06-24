# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProjectCountries, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProjectCountries (
        $countriesSlugs: [String!]!
        $slug: String!
        ) {
          updateProjectCountries (
            countriesSlugs: $countriesSlugs
            slug: $slug
          ) {
            project {
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

  it 'is successful - user is logged in as admin' do
    create(:project, name: 'Some Name', slug: 'some_name', countries: [create(:country, slug: 'c_1', name: 'C 1')])
    create(:country, slug: 'c_2', name: 'C 2')
    create(:country, slug: 'c_3', name: 'C 3')
    expect_any_instance_of(Mutations::UpdateProjectCountries).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { countriesSlugs: ['c_2', 'c_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectCountries']['project'])
        .to(eq({ "slug" => "some_name", "countries" => [{ "slug" => "c_2" }, { "slug" => "c_3" }] }))
      expect(result['data']['updateProjectCountries']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as product owner' do
    create(:project, name: 'Some Name', slug: 'some_name', countries: [create(:country, slug: 'c_1', name: 'C 1')],
                     organizations: [create(:organization, slug: 'org_1', name: 'Org 1')],
                     products: [create(:product, id: 1)])
    create(:country, slug: 'c_2', name: 'C 2')
    create(:country, slug: 'c_3', name: 'C 3')
    expect_any_instance_of(Mutations::UpdateProjectCountries).to(receive(:product_owner_check_for_project)
      .and_return(true))

    result = execute_graphql(
      mutation,
      variables: { countriesSlugs: ['c_2', 'c_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectCountries']['project'])
        .to(eq({ "slug" => "some_name", "countries" => [{ "slug" => "c_2" }, { "slug" => "c_3" }] }))
      expect(result['data']['updateProjectCountries']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as organization owner' do
    create(:project, name: 'Some Name', slug: 'some_name', countries: [create(:country, slug: 'c_1', name: 'C 1')],
                     organizations: [create(:organization, slug: 'org_1', name: 'Org 1')],
                     products: [create(:product, id: 1)])
    create(:country, slug: 'c_2', name: 'C 2')
    create(:country, slug: 'c_3', name: 'C 3')
    expect_any_instance_of(Mutations::UpdateProjectCountries).to(receive(:org_owner_check_for_project).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { countriesSlugs: ['c_2', 'c_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectCountries']['project'])
        .to(eq({ "slug" => "some_name", "countries" => [{ "slug" => "c_2" }, { "slug" => "c_3" }] }))
      expect(result['data']['updateProjectCountries']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:project, name: 'Some Name', slug: 'some_name', countries: [create(:country, slug: 'c_1', name: 'C 1')])
    create(:country, slug: 'c_2', name: 'C 2')
    create(:country, slug: 'c_3', name: 'C 3')

    result = execute_graphql(
      mutation,
      variables: { countriesSlugs: ['c_2', 'c_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectCountries']['project'])
        .to(eq(nil))
      expect(result['data']['updateProjectCountries']['errors'])
        .to(eq(['Must have proper rights to update a project']))
    end
  end
end
