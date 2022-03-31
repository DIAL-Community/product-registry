# frozen_string_literal: true

module Types
  class OperatorServiceType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :service, String, null: false

    field :country_id, Integer, null: true
  end

  class CapabilityType < Types::BaseObject
    field :id, ID, null: false
    field :service, String, null: false
    field :capability, String, null: false

    field :country_id, Integer, null: true
    field :aggregator_id, Integer, null: false
    field :operator_service_id, Integer, null: false
  end
end
