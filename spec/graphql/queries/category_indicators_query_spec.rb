# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::CategoryIndicatorQuery, type: :graphql) do
  let(:detail_query) do
    <<~GQL
      query CategoryIndicator ($slug: String!) {
        categoryIndicator (slug: $slug) {
          name
          slug
          weight
        }
      }
    GQL
  end

  it 'pulls specific category indicator - user is logged as admin' do
    create(:rubric_category, name: 'Some Rubric Category', slug: 'some_rubric_category', weight: 0.75, id: 1)
    create(:category_indicator, name: 'Some Category Indicator', slug: 'some_category_indicator', weight: 0.75,
                                rubric_category_id: 1)
    expect_any_instance_of(Queries::CategoryIndicatorQuery).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      detail_query,
      variables: { slug: 'some_category_indicator' }
    )

    aggregate_failures do
      expect(result['data']['categoryIndicator']).to(eq({ "name" => "Some Category Indicator",
                                                          "slug" => "some_category_indicator",
                                                          "weight" => 0.75 }))
    end
  end

  it 'pulls null rubric category - user is not logged as admin' do
    create(:rubric_category, name: 'Some Rubric Category', slug: 'some_rubric_category', weight: 0.75, id: 1)
    create(:category_indicator, name: 'Some Category Indicator', slug: 'some_category_indicator', weight: 0.75,
                                rubric_category_id: 1)
    expect_any_instance_of(Queries::CategoryIndicatorQuery).to(receive(:an_admin).and_return(false))

    result = execute_graphql(
      detail_query,
      variables: { slug: 'some_category_indicator' }
    )

    aggregate_failures do
      expect(result['data']['categoryIndicator']).to(eq(nil))
    end
  end
end
