# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreatePlaybook, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreatePlaybook (
        $name: String!,
        $slug: String!,
        $overview: String!
      ) {
        createPlaybook(
          name: $name,
          slug: $slug,
          overview: $overview,
          author: "Some Author"
        ) {
          playbook {
            name
            slug
            playbookDescription{
              overview
            }
            author
          }
        }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    expect_any_instance_of(Mutations::CreatePlaybook).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some_name", overview: "Some Overview" },
    )

    aggregate_failures do
      expect(result['data']['createPlaybook']['playbook'])
        .to(eq({ "name" => "Some name", "slug" => "some_name",
                 "playbookDescription" => { "overview" => "Some Overview" }, "author" => "Some Author" }))
    end
  end

  it 'is successful - user is logged in as content editor' do
    expect_any_instance_of(Mutations::CreatePlaybook).to(receive(:a_content_editor).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some_name", overview: "Some Overview" },
    )

    aggregate_failures do
      expect(result['data']['createPlaybook']['playbook'])
        .to(eq({ "name" => "Some name", "slug" => "some_name",
                 "playbookDescription" => { "overview" => "Some Overview" }, "author" => "Some Author" }))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some_name", overview: "Some Overview" },
    )

    aggregate_failures do
      expect(result['data']['createPlaybook']['playbook'])
        .to(eq(nil))
    end
  end

  it 'fails - user has not proper rights' do
    expect_any_instance_of(Mutations::CreatePlaybook).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::CreatePlaybook).to(receive(:a_content_editor).and_return(false))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some_name", overview: "Some Overview" },
    )

    aggregate_failures do
      expect(result['data']['createPlaybook']['playbook'])
        .to(eq(nil))
    end
  end
end
