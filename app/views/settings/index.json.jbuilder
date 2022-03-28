# frozen_string_literal: true

json.array! @settings, partial: 'settings/setting', as: :setting
