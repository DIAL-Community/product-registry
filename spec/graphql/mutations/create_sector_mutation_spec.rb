# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateSector, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateSector(
        $name: String!,
        $slug: String!,
        $isDisplayable: Boolean!,
        $originId: Int,
        $parentSectorId: Int,
        $locale: String
      ) {
        createSector(
          name: $name,
          slug: $slug,
          isDisplayable: $isDisplayable,
          originId: $originId,
          parentSectorId: $parentSectorId,
          locale: $locale
        ) {
            sector {
              name
              slug
              locale
              isDisplayable
            }
            errors
          }
        }
    GQL
  end

  let(:sector_query) do
    <<~GQL
      query Sector($slug: String!) {
        sector(slug: $slug) {
          name
          slug
          originId
        }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    origin = create(:origin, name: "Example Origin", slug: "example_origin")
    expect_any_instance_of(Mutations::CreateSector).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: {
        name: "Some name",
        slug: "some_name",
        isDisplayable: false,
        originId: origin.id,
        parentSectorId: nil
      },
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Some name", "slug" => "some_name", "locale" => "en", "isDisplayable" => false }))
    end
  end

  it 'is successful - missing locale will store the correct with current locale value' do
    create(:origin, name: "Manually Entered", slug: "manually_entered")
    expect_any_instance_of(Mutations::CreateSector).to(receive(:an_admin).and_return(true))

    # Creating new sector using random origin id
    result = execute_graphql(
      mutation,
      variables: {
        name: "Without Locale",
        slug: "without_locale",
        isDisplayable: false
      }
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Without Locale", "slug" => "without_locale", "locale" => "en", "isDisplayable" => false }))
    end
  end

  it 'is successful - valid locale will store the correct value' do
    create(:origin, name: "Manually Entered", slug: "manually_entered")
    expect_any_instance_of(Mutations::CreateSector).to(receive(:an_admin).and_return(true))

    # Creating new sector using random origin id
    result = execute_graphql(
      mutation,
      variables: {
        name: "DE Locale",
        slug: "de_locale",
        isDisplayable: false,
        locale: 'de'
      }
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "DE Locale", "slug" => "de_locale", "locale" => "de", "isDisplayable" => false }))
    end
  end

  it 'is successful - random locale will be replaced with current locale value' do
    create(:origin, name: "Manually Entered", slug: "manually_entered")
    expect_any_instance_of(Mutations::CreateSector).to(receive(:an_admin).and_return(true))

    # Creating new sector using random origin id
    result = execute_graphql(
      mutation,
      variables: {
        name: "Random Locale",
        slug: "random_locale",
        isDisplayable: false,
        locale: 'some-non-locale-value'
      }
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Random Locale", "slug" => "random_locale", "locale" => "en", "isDisplayable" => false }))
    end
  end

  it 'is successful - setting the origin to default when value is random' do
    origin = create(:origin, name: "Manually Entered", slug: "manually_entered")
    expect_any_instance_of(Mutations::CreateSector).to(receive(:an_admin).and_return(true))

    # Creating new sector using random origin id
    result = execute_graphql(
      mutation,
      variables: {
        name: "Random Origin",
        slug: "random_origin",
        isDisplayable: false,
        originId: origin.id + 99
      }
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Random Origin", "slug" => "random_origin", "locale" => "en", "isDisplayable" => false }))
    end

    query_result = execute_graphql(
      sector_query,
      variables: {
        slug: "random_origin"
      }
    )

    aggregate_failures do
      expect(query_result['data']['sector'])
        .to(eq({ "name" => "Random Origin", "slug" => "random_origin", "originId" => origin.id }))
    end
  end

  it 'is successful - setting the origin to default value of manually entered' do
    origin = create(:origin, name: "Manually Entered", slug: "manually_entered")
    expect_any_instance_of(Mutations::CreateSector).to(receive(:an_admin).and_return(true))

    # Creating new sector using only required fields.
    result = execute_graphql(
      mutation,
      variables: {
        name: "Some name",
        slug: "some_name",
        isDisplayable: false
      }
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Some name", "slug" => "some_name", "locale" => "en", "isDisplayable" => false }))
    end

    query_result = execute_graphql(
      sector_query,
      variables: {
        slug: "some_name"
      }
    )

    aggregate_failures do
      expect(query_result['data']['sector'])
        .to(eq({ "name" => "Some name", "slug" => "some_name", "originId" => origin.id }))
    end
  end

  it 'is successful - creating sector with duplicate name' do
    origin = create(:origin, name: "Example Origin", slug: "example_origin")
    graph_variables = {
      name: "Some name",
      slug: "",
      isDisplayable: false,
      originId: origin.id,
      parentSectorId: nil
    }

    allow_any_instance_of(Mutations::CreateSector).to(receive(:an_admin).and_return(true))
    result = execute_graphql(
      mutation,
      variables: graph_variables,
    )

    # First sector creation should use normal slug.
    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Some name", "slug" => "some_name", "locale" => "en", "isDisplayable" => false }))
    end

    result = execute_graphql(
      mutation,
      variables: graph_variables,
    )

    # The following create should add _dupX to the slug when creating sector using the same name.
    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Some name", "slug" => "some_name_dup0", "locale" => "en", "isDisplayable" => false }))
    end

    result = execute_graphql(
      mutation,
      variables: graph_variables,
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Some name", "slug" => "some_name_dup1", "locale" => "en", "isDisplayable" => false }))
    end
  end

  it 'is successful - admin can update sector name and slug remains the same' do
    origin = create(:origin, name: "Example Origin", slug: "example_origin")
    create(:sector, name: "Some name", slug: "some_name", is_displayable: false, origin_id: origin.id, locale: 'en')
    expect_any_instance_of(Mutations::CreateSector).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: {
        name: "Some new name",
        slug: "some_name",
        isDisplayable: false,
        originId: origin.id,
        parentSectorId: nil
      }
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Some new name", "slug" => "some_name", "locale" => "en", "isDisplayable" => false }))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: {
        name: "Some name",
        slug: "some_name",
        isDisplayable: false,
        originId: 1,
        parentSectorId: nil
      }
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(be(nil))
    end
  end
end
