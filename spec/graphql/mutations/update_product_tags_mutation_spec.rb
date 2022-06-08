# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProductTags, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProductTags (
        $tags: [String!]!
        $slug: String!
        ) {
          updateProductTags (
            tags: $tags
            slug: $slug
          ) {
            product {
              slug
              tags
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:product, name: 'Some Name', slug: 'some_name', tags: ['tag_1'])
    expect_any_instance_of(Mutations::UpdateProductTags).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { tags: ['tag_2', 'tag_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProductTags']['product'])
        .to(eq({ "slug" => "some_name", "tags" => ["tag_2", "tag_3"] }))
      expect(result['data']['updateProductTags']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:product, name: 'Some Name', slug: 'some_name', tags: ['tag_1'])

    result = execute_graphql(
      mutation,
      variables: { tags: ['tag_2', 'tag_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProductTags']['product'])
        .to(eq(nil))
      expect(result['data']['updateProductTags']['errors'])
        .to(eq(['Must be admin or product owner to update a product']))
    end
  end
end
