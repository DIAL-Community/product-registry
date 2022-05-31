# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreatePlay, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreatePlay (
        $name: String!,
        $slug: String!,
        $description: String!
      ) {
        createPlay (
          name: $name,
          slug: $slug,
          description: $description
        ) {
          play {
            name
            slug
            playDescription{
              description
            }
          }
        }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    expect_any_instance_of(Mutations::CreatePlay).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some_name", description: "Some Description" },
    )

    aggregate_failures do
      expect(result['data']['createPlay']['play'])
        .to(eq("name" => "Some name", "slug" => "some_name",
        "playDescription" => { "description" => "Some Description" }))
    end
  end

  it 'is successful - user is logged in as content editor' do
    expect_any_instance_of(Mutations::CreatePlay).to(receive(:a_content_editor).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some_name", description: "Some Description" },
    )

    aggregate_failures do
      expect(result['data']['createPlay']['play'])
        .to(eq("name" => "Some name", "slug" => "some_name",
        "playDescription" => { "description" => "Some Description" }))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some_name", description: "Some Description" },
    )

    aggregate_failures do
      expect(result['data']['createPlay'])
        .to(eq(nil))
    end
  end

  it 'fails - user has not proper rights' do
    expect_any_instance_of(Mutations::CreatePlay).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::CreatePlay).to(receive(:a_content_editor).and_return(false))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some_name", description: "Some Description" },
    )

    aggregate_failures do
      expect(result['data']['createPlay'])
        .to(eq(nil))
    end
  end
end
