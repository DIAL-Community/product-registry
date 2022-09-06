# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::RubricCategoriesQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query RubricCategories {
        rubricCategories {
          nodes {
          name
          slug
          weight
          }
          totalCount
        }
      }
    GQL
  end

  it 'pulls list of rubric categories - user is logged as admin' do
    expect_any_instance_of(Queries::RubricCategoriesQuery).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      query
    )

    aggregate_failures do
      expect(result['data']['rubricCategories']['nodes'][0]).not_to(eq([]))
    end
  end

  it 'pulls empty list - user is not logged as admin' do
    expect_any_instance_of(Queries::RubricCategoriesQuery).to(receive(:an_admin).and_return(false))

    result = execute_graphql(
      query
    )

    aggregate_failures do
      expect(result['data']['rubricCategories']['nodes']).to(eq([]))
    end
  end
end
