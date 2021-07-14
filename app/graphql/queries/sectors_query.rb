module Queries
  class SectorsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :locale, String, required: false, default_value: 'en'
    type [Types::SectorType], null: false

    def resolve(search:, locale:)
      sectors = Sector.where(is_displayable: true, locale: locale).order(:name)
      unless search.blank?
        sectors = sectors.name_contains(search)
      end
      sectors
    end
  end

  class SectorsWithSubsQuery < Queries::BaseQuery
    argument :locale, String, required: false, default_value: 'en'
    type [Types::SectorType], null: false

    def resolve(locale:)
      sectors = Sector.where(parent_sector_id: nil, is_displayable: true, locale: locale).order(:name)
      sectors
    end
  end

  class SearchSectorsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    argument :locale, String, required: false, default_value: 'en'

    type Types::SectorType.connection_type, null: false

    def resolve(search:, locale:)
      sectors = Sector.where(is_displayable: true, locale: locale, parent_sector_id: nil).order(:name)
      unless search.blank?
        sectors = sectors.name_contains(search)
      end
      sectors
    end
  end
end
