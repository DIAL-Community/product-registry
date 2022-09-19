# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteRubricCategory, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteRubricCategory (
        $id: ID!
        ) {
        deleteRubricCategory(
          id: $id
        ) {
            rubricCategory
            {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:rubric_category, id: 1000, name: 'Some RC', slug: 'some_rc')
    expect_any_instance_of(Mutations::DeleteRubricCategory).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteRubricCategory']['rubricCategory'])
        .to(be(nil))
      expect(result['data']['deleteRubricCategory']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:rubric_category, id: 1000, name: 'Some RC', slug: 'some_rc')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteRubricCategory']['rubricCategory'])
        .to(be(nil))
      expect(result['data']['deleteRubricCategory']['errors'])
        .to(eq(["Must be admin to delete a rubric category"]))
    end
  end
end
