# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteTag, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteTag ($id: ID!) {
        deleteTag(id: $id) {
            tag {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:tag, id: 1000, name: 'Some Tag', slug: 'some_tag')
    expect_any_instance_of(Mutations::DeleteTag).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteTag']['tag'])
        .to(eq({ 'id' => '1000' }))
      expect(result['data']['deleteTag']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:tag, id: 1000, name: 'Some Tag', slug: 'some_tag')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteTag']['tag'])
        .to(be(nil))
      expect(result['data']['deleteTag']['errors'])
        .to(eq(["Must be admin to delete a tag."]))
    end
  end
end
