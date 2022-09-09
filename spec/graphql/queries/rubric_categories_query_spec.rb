# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::RubricCategoriesQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query RubricCategories (
        $search: String
      ) {
        rubricCategories (
          search: $search
        ) {
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

  let(:detail_query) do
    <<~GQL
      query RubricCategory ($slug: String!) {
        rubricCategory (slug: $slug) {
          name
          slug
          weight
        }
      }
    GQL
  end

  it 'pulls list of rubric categories - user is logged as admin' do
    create(:rubric_category, name: 'Some Rubric Category', slug: 'some_rubric_category', weight: 0.75)
    expect_any_instance_of(Queries::RubricCategoriesQuery).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      query,
      variables: { search: 'Some' }
    )

    aggregate_failures do
      expect(result['data']['rubricCategories']['nodes']).to(eq([{ "name" => "Some Rubric Category",
                                                                   "slug" => "some_rubric_category",
                                                                   "weight" => 0.75 }]))
    end
  end

  it 'pulls empty list - user is not logged as admin' do
    create(:rubric_category, name: 'Some Rubric Category', slug: 'some_rubric_category', weight: 0.75)
    expect_any_instance_of(Queries::RubricCategoriesQuery).to(receive(:an_admin).and_return(false))

    result = execute_graphql(
      query,
      variables: { search: 'Some' }
    )

    aggregate_failures do
      expect(result['data']['rubricCategories']['nodes']).to(eq([]))
    end
  end

  it 'pulls specific rubric category - user is logged as admin' do
    create(:rubric_category, name: 'Some Rubric Category', slug: 'some_rubric_category', weight: 0.75)
    expect_any_instance_of(Queries::RubricCategoryQuery).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      detail_query,
      variables: { slug: 'some_rubric_category' }
    )

    aggregate_failures do
      expect(result['data']['rubricCategory']).to(eq({ "name" => "Some Rubric Category",
                                                       "slug" => "some_rubric_category",
                                                       "weight" => 0.75 }))
    end
  end

  it 'pulls null rubric category - user is not logged as admin' do
    create(:rubric_category, name: 'Some Rubric Category', slug: 'some_rubric_category', weight: 0.75)
    expect_any_instance_of(Queries::RubricCategoryQuery).to(receive(:an_admin).and_return(false))

    result = execute_graphql(
      detail_query,
      variables: { slug: 'some_rubric_category' }
    )

    aggregate_failures do
      expect(result['data']['rubricCategory']).to(eq(nil))
    end
  end
end
