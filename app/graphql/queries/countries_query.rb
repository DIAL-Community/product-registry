# frozen_string_literal: true

module Queries
  class CountriesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CountryType], null: false

    def resolve(search:)
      countries = Country.order(:name)
      countries = countries.name_contains(search) unless search.blank?
      countries
    end
  end

  class CountryQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CountryType, null: false

    def resolve(slug:)
      Country.find_by(slug: slug)
    end
  end

  class SearchCountriesQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    type Types::CountryType.connection_type, null: false

    def resolve(search:)
      countries = Country.order(:name)
      countries = countries.name_contains(search) unless search.blank?
      countries
    end
  end
end
