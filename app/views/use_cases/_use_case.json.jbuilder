# frozen_string_literal: true

json.extract!(use_case, :id, :name, :slug, :sector_id, :created_at, :updated_at)
json.url(use_case_url(use_case, format: :json))

json.use_case_descriptions(use_case.use_case_descriptions) do |uc_desc|
  json.extract!(uc_desc, :description, :locale)
end

json.use_case_steps(use_case.use_case_steps) do |uc_step|
  json.extract!(uc_step, :name)
  json.use_case_step_descriptions(uc_step.use_case_step_descriptions) do |uc_step_desc|
    json.extract!(uc_step_desc, :description, :locale)
  end
end
