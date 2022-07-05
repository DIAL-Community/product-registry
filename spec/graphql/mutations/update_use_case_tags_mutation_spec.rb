# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateUseCaseTags, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateUseCaseTags (
        $tags: [String!]!
        $slug: String!
        ) {
          updateUseCaseTags (
            tags: $tags
            slug: $slug
          ) {
            useCase {
              slug
              tags
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:use_case, name: 'Some Name', slug: 'some_name', tags: ['tag_1'])
    expect_any_instance_of(Mutations::UpdateUseCaseTags).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { tags: ['tag_2', 'tag_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseTags']['useCase'])
        .to(eq({ "slug" => "some_name", "tags" => ["tag_2", "tag_3"] }))
      expect(result['data']['updateUseCaseTags']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    create(:use_case, name: 'Some Name', slug: 'some_name', tags: ['tag_1'])
    expect_any_instance_of(Mutations::UpdateUseCaseTags).to(receive(:a_content_editor).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { tags: ['tag_2', 'tag_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseTags']['useCase'])
        .to(eq({ "slug" => "some_name", "tags" => ["tag_2", "tag_3"] }))
      expect(result['data']['updateUseCaseTags']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user has not proper rights' do
    create(:use_case, name: 'Some Name', slug: 'some_name', tags: ['tag_1'])
    expect_any_instance_of(Mutations::UpdateUseCaseTags).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::UpdateUseCaseTags).to(receive(:a_content_editor).and_return(false))

    result = execute_graphql(
      mutation,
      variables: { tags: ['tag_2', 'tag_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseTags']['useCase'])
        .to(eq(nil))
      expect(result['data']['updateUseCaseTags']['errors'])
        .to(eq(['Must be an admin or content editor to update use case']))
    end
  end

  it 'is fails - user is not logged in' do
    create(:use_case, name: 'Some Name', slug: 'some_name', tags: ['tag_1'])

    result = execute_graphql(
      mutation,
      variables: { tags: ['tag_2', 'tag_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseTags']['useCase'])
        .to(eq(nil))
      expect(result['data']['updateUseCaseTags']['errors'])
        .to(eq(['Must be an admin or content editor to update use case']))
    end
  end
end
