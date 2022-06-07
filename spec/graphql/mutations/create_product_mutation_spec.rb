# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateProduct, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateProduct (
        $name: String!,
        $slug: String!,
        $description: String!
        ) {
        createProduct(
          name: $name,
          slug: $slug,
          aliases: {},
          website: "somewebsite.org",
          description: $description
        ) {
            product
            {
              name
              slug
              productDescription {
                description
              }
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    expect_any_instance_of(Mutations::CreateProduct).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some_name", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createProduct']['product'])
        .to(eq({ "name" => "Some name", "productDescription" => { "description" => "some description" },
                 "slug" => "some_name" }))
      expect(result['data']['createProduct']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some_name", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createProduct']['product'])
        .to(be(nil))
      expect(result['data']['createProduct']['errors'])
        .to(eq(['Must be admin or product owner to create an product']))
    end
  end
end
