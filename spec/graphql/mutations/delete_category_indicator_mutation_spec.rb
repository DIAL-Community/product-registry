# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteCategoryIndicator, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteCategoryIndicator (
        $id: ID!
        ) {
        deleteCategoryIndicator(
          id: $id
        ) {
            categoryIndicator
            {
              id
            }
            rubricCategorySlug
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:rubric_category, id: 1000, name: 'Some RC', slug: 'some_rc')
    create(:category_indicator, id: 1000, name: 'Some CI', slug: 'some_ci', rubric_category_id: 1000)
    expect_any_instance_of(Mutations::DeleteCategoryIndicator).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteCategoryIndicator']['categoryIndicator'])
        .to(be(nil))
      expect(result['data']['deleteCategoryIndicator']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:rubric_category, id: 5, name: 'Some RC', slug: 'some_rc')
    create(:category_indicator, id: 1000, name: 'Some CI', slug: 'some_ci', rubric_category_id: 5)

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteCategoryIndicator']['categoryIndicator'])
        .to(be(nil))
      expect(result['data']['deleteCategoryIndicator']['errors'])
        .to(eq(["Must be admin to delete a category indicator"]))
    end
  end
end
