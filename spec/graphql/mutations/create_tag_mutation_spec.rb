# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateTag, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateTag(
        $name: String!,
        $slug: String!,
        $description: String!
      ) {
        createTag(
          name: $name,
          slug: $slug,
          description: $description
        ) {
            tag {
              name
              slug
            }
            errors
          }
        }
    GQL
  end

  let(:query) do
    <<~GQL
      query Product($slug: String!) {
        product (slug: $slug) {
          slug
          name
          tags
        }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    expect_any_instance_of(Mutations::CreateTag).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: {
        name: "Some name",
        slug: "some_name",
        description: 'Some description'
      }
    )

    aggregate_failures do
      expect(result['data']['createTag']['tag'])
        .to(eq({ "name" => "Some name", "slug" => "some_name" }))
    end
  end

  it 'is successful - admin can update tag name and slug remains the same' do
    create(:tag, name: "Some name", slug: "some_name")
    expect_any_instance_of(Mutations::CreateTag).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: {
        name: "Some new name",
        slug: "some_name",
        description: 'Some description'
      }
    )

    aggregate_failures do
      expect(result['data']['createTag']['tag'])
        .to(eq({ "name" => "Some new name", "slug" => "some_name" }))
    end
  end

  it 'is successful - should update references on other objects' do
    create(:tag, name: "Some Name", slug: "some_name")
    create(:product, name: "Some Product", slug: "some_product", tags: ['Some Name'])
    expect_any_instance_of(Mutations::CreateTag).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: {
        name: "Some New Name",
        slug: "some_name",
        description: 'Some description'
      }
    )

    # Get product using the above tag and ensure the reference is updated.
    product_result = execute_graphql(
      query,
      variables: {
        slug: 'some_product'
      }
    )

    aggregate_failures do
      expect(result['data']['createTag']['tag'])
        .to(eq({ "name" => "Some New Name", "slug" => "some_name" }))
      # The tag update operation should also update tag list in the product object.
      expect(product_result['data']['product']['tags']).to(eq(['Some New Name']))
    end
  end

  # Preventing duplicate tag with the same name because name is used in other objects.
  it 'is successful - prevent tag with the same name to create duplicate' do
    graph_variables = {
      name: "Some Name",
      slug: "",
      description: 'Some description'
    }

    allow_any_instance_of(Mutations::CreateTag).to(receive(:an_admin).and_return(true))
    result = execute_graphql(
      mutation,
      variables: graph_variables,
    )

    # First tag creation should use normal slug.
    aggregate_failures do
      expect(result['data']['createTag']['tag'])
        .to(eq({ "name" => "Some Name", "slug" => "some_name" }))
    end

    result = execute_graphql(
      mutation,
      variables: graph_variables,
    )

    # The following create should add _dupX to the slug when creating tag using the same name.
    aggregate_failures do
      expect(result['data']['createTag']['tag'])
        .to(eq({ "name" => "Some Name", "slug" => "some_name" }))
    end

    result = execute_graphql(
      mutation,
      variables: graph_variables,
    )

    aggregate_failures do
      expect(result['data']['createTag']['tag'])
        .to(eq({ "name" => "Some Name", "slug" => "some_name" }))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: {
        name: "Some name",
        slug: "some_name",
        description: 'Some description'
      }
    )

    aggregate_failures do
      expect(result['data']['createTag']['tag'])
        .to(be(nil))
    end
  end
end
