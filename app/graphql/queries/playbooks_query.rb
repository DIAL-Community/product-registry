module Queries
  class PlaybooksQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::PlaybookType], null: false

    def resolve(search:)
      playbooks = Playbook.all.order(:name)
      unless search.blank?
        playbooks = playbooks.name_contains(search)
      end
      playbooks
    end
  end

  class PlaybookQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::PlaybookType, null: false

    def resolve(slug:)
      Playbook.find_by(slug: slug)
    end
  end

  class SearchPlaybooksQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    argument :products, [String], required: false, default_value: []

    type Types::PlaybookType.connection_type, null: false

    def resolve(search:, products:)
      playbooks = Playbook.all.order(:name)
      if !search.nil? && !search.to_s.strip.empty?
        name_playbooks = playbooks.name_contains(search)
        desc_playbooks = playbooks.joins(:playbook_descriptions)
                                  .where("LOWER(description) like LOWER(?)", "%#{search}%")
        playbooks = playbooks.where(id: (name_playbooks + desc_playbooks).uniq)
      end

      filtered_products = products.reject { |x| x.nil? || x.empty? }
      unless filtered_products.empty?
        playbooks = playbooks.joins(:products)
                             .where(products: { id: filtered_products })
      end

      playbooks.distinct
    end
  end
end
