# frozen_string_literal: true

json.array! @countries, partial: 'countries/country', as: :country
