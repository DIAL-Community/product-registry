# frozen_string_literal: true

json.extract!(use_case_step, :id, :name, :slug, :step_number, :use_case_id, :created_at, :updated_at)
json.url(use_case_step_url(use_case_step, format: :json))
