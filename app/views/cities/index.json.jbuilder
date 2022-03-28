# frozen_string_literal: true

json.array! @cities, partial: 'cities/city', as: :city
