# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateUseCaseSdgTargets, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateUseCaseSdgTargets (
        $sdgTargetsIds: [Int!]!
        $slug: String!
        ) {
          updateUseCaseSdgTargets (
            sdgTargetsIds: $sdgTargetsIds
            slug: $slug
          ) {
            useCase {
              slug
              sdgTargets {
                id
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:use_case, name: 'Some Name', slug: 'some_name',
                      sdg_targets: [create(:sdg_target, slug: 'sdg_targ_1', name: 'Sdg_targ 1', id: 1)])
    create(:sdg_target, slug: 'sdg_targ_2', name: 'Sdg_targ 2', id: 2)
    create(:sdg_target, slug: 'sdg_targ_3', name: 'Sdg_targ 3', id: 3)
    expect_any_instance_of(Mutations::UpdateUseCaseSdgTargets).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { sdgTargetsIds: [2, 3], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseSdgTargets']['useCase'])
        .to(eq({ "slug" => "some_name", "sdgTargets" => [{ "id" => "2" }, { "id" => "3" }] }))
      expect(result['data']['updateUseCaseSdgTargets']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    create(:use_case, name: 'Some Name', slug: 'some_name',
                      sdg_targets: [create(:sdg_target, slug: 'sdg_targ_1', name: 'Sdg_targ 1', id: 1)])
    create(:sdg_target, slug: 'sdg_targ_2', name: 'Sdg_targ 2', id: 2)
    create(:sdg_target, slug: 'sdg_targ_3', name: 'Sdg_targ 3', id: 3)
    expect_any_instance_of(Mutations::UpdateUseCaseSdgTargets).to(receive(:a_content_editor).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { sdgTargetsIds: [2, 3], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseSdgTargets']['useCase'])
        .to(eq({ "slug" => "some_name", "sdgTargets" => [{ "id" => "2" }, { "id" => "3" }] }))
      expect(result['data']['updateUseCaseSdgTargets']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:use_case, name: 'Some Name', slug: 'some_name',
                      sdg_targets: [create(:sdg_target, slug: 'sdg_targ_1', name: 'Sdg_targ 1', id: 1)])
    create(:sdg_target, slug: 'sdg_targ_2', name: 'Sdg_targ 2', id: 2)
    create(:sdg_target, slug: 'sdg_targ_3', name: 'Sdg_targ 3', id: 3)

    result = execute_graphql(
      mutation,
      variables: { sdgTargetsIds: [2, 3], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseSdgTargets']['useCase'])
        .to(eq(nil))
      expect(result['data']['updateUseCaseSdgTargets']['errors'])
        .to(eq(['Must be an admin or content editor to update use case']))
    end
  end
end
