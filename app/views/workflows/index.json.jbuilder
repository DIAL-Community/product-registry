# frozen_string_literal: true

json.array! @workflows, partial: 'workflows/workflow', as: :workflow
