# frozen_string_literal: true

json.extract! candidate_role, :id, :email, :roles, :rejected, :rejected_date, :rejected_by_id, :approved_date,
              :approved_by_id, :created_at, :updated_at
json.url candidate_role_url(candidate_role, format: :json)
