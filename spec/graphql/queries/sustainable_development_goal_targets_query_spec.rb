# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::SustainableDevelopmentGoalTargetsQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query
        SdgTargets (
          $search: String
        ) {
          sdgTargets (
            search: $search
          ) {
            id
            name
          }
        }
    GQL
  end

  it 'searches existing SDG Target' do
    create(:sdg_target, name: 'Some Random Target')

    result = execute_graphql(
      query,
      variables: { "search": "Random" }
    )

    aggregate_failures do
      expect(result['data']['sdgTargets'].count).to(eq(1))
    end
  end

  it 'do not return not existing SDG Target' do
    result = execute_graphql(
      query,
      variables: { "search": "Random" }
    )

    aggregate_failures do
      expect(result['data']['sdgTargets'].count).to(eq(0))
    end
  end
end
