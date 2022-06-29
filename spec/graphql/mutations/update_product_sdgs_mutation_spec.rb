# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProductSdgs, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProductSdgs (
        $sdgsSlugs: [String!]!
        $slug: String!
        $mappingStatus: String!
        ) {
          updateProductSdgs (
            sdgsSlugs: $sdgsSlugs
            slug: $slug
            mappingStatus: $mappingStatus
          ) {
            product {
              slug
              sustainableDevelopmentGoals {
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
                      sustainable_development_goals: [])
    create(:sustainable_development_goal, slug: 'sdg_2', name: 'SDG 2')
    create(:sustainable_development_goal, slug: 'sdg_3', name: 'SDG 3')
    expect_any_instance_of(Mutations::UpdateProductSdgs).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { sdgsSlugs: ['sdg_2', 'sdg_3'], slug: 'some_name', mappingStatus: 'VALIDATED' },
    )

    aggregate_failures do
      expect(result['data']['updateProductSdgs']['product'])
        .to(eq({ "slug" => "some_name",
                 "sustainableDevelopmentGoals" => [{ "slug" => "sdg_2" }, { "slug" => "sdg_3" }] }))
      expect(result['data']['updateProductSdgs']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:product, name: 'Some Name', slug: 'some_name',
                      sustainable_development_goals: [])
    create(:sustainable_development_goal, slug: 'sdg_2', name: 'SDG 2')
    create(:sustainable_development_goal, slug: 'sdg_3', name: 'SDG 3')

    result = execute_graphql(
      mutation,
      variables: { sdgsSlugs: ['sdg_2', 'sdg_3'], slug: 'some_name', mappingStatus: 'VALIDATED' },
    )

    aggregate_failures do
      expect(result['data']['updateProductSdgs']['product'])
        .to(eq(nil))
      expect(result['data']['updateProductSdgs']['errors'])
        .to(eq(['Must be admin or product owner to update a product']))
    end
  end
end
