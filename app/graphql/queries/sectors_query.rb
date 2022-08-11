# frozen_string_literal: true

module Queries
  class SectorsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :locale, String, required: false, default_value: 'en'
    type [Types::SectorType], null: false

    def resolve(search:, locale:)
      sectors = Sector.where(is_displayable: true, locale: locale).order(:name)
      sectors = sectors.name_contains(search) unless search.blank?
      sectors
    end
  end

  class SectorQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::SectorType, null: false

    def resolve(slug:)
      Sector.find_by(slug: slug)
    end
  end

  class SectorsWithSubsQuery < Queries::BaseQuery
    argument :locale, String, required: false, default_value: 'en'
    type [Types::SectorType], null: false

    def resolve(locale:)
      Sector.where(parent_sector_id: nil, is_displayable: true, locale: locale).order(:name)
    end
  end

  class SearchSectorsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''

    argument :locale, String, required: false, default_value: nil
    argument :parent_sector_id, Integer, required: false, default_value: nil
    argument :is_displayable, Boolean, required: false, default_value: nil

    type Types::SectorType.connection_type, null: false

    def resolve(search:, locale:, parent_sector_id:, is_displayable:)
      sectors = Sector.order(:name)

      sectors = sectors.where(locale: locale) unless locale.nil?
      sectors = sectors.where(parent_sector_id: parent_sector_id) unless parent_sector_id.nil?
      sectors = sectors.where(is_displayable: is_displayable) unless is_displayable.nil?

      sectors = sectors.name_contains(search) unless search.blank?
      sectors
    end
  end
end
