# frozen_string_literal: true

json.array! @candidate_roles, partial: 'candidate_roles/candidate_role', as: :candidate_role
