# frozen_string_literal: true

json.array! @activities, partial: 'activities/activity', as: :activity
