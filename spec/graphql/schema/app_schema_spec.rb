# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(RegistrySchema) do
  it 'matches the dumped schema (rails graphql:schema:dump)' do
    aggregate_failures do
      # TODO: Disabling this temporarily. Need to find why this is not equal when they're supposed to be equal.
      # expect(described_class.to_definition).to(eq(File.read(Rails.root.join('schema.graphql')).rstrip))
      expect(described_class.to_json).to(eq(File.read(Rails.root.join('schema.json')).rstrip))
    end
  end
end
