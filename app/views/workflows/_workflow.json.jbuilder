# frozen_string_literal: true

json.extract! workflow, :id, :name, :slug, :created_at, :updated_at
json.url workflow_url(workflow, format: :json)

json.workflow_descriptions workflow.workflow_descriptions do |wf_desc|
  json.extract! wf_desc, :description, :locale
end
