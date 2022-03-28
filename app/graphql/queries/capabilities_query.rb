# frozen_string_literal: true

module Queries
  class CapabilitiesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :capabilities, [String], required: false, default_value: []
    argument :services, [String], required: false, default_value: []
    argument :country_ids, [Integer], required: false, default_value: []
    argument :aggregator_ids, [Integer], required: false, default_value: []

    type [Types::CapabilityType], null: false

    def resolve(search:, capabilities:, services:, country_ids:, aggregator_ids:)
      capability_data = AggregatorCapability.order(service: :asc, capability: :asc)
      capability_data = capability_data.name_contains(search) unless search.blank?

      capability_data = capability_data.where(country_id: country_ids) unless country_ids.empty?

      capability_data = capability_data.where(aggregator_id: aggregator_ids) unless aggregator_ids.empty?

      filtered_capabilities = capabilities.reject { |x| x.nil? || x.empty? }
      capability_data = capability_data.where(capability: filtered_capabilities) unless filtered_capabilities.empty?

      filtered_services = services.reject { |x| x.nil? || x.empty? }
      capability_data = capability_data.where(service: filtered_services) unless filtered_services.empty?
      capability_data
    end
  end

  class CapabilityOnlyQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CapabilityType], null: false

    def resolve(search:)
      capabilities = AggregatorCapability.select(:service, :capability).distinct
      unless search.blank?
        capabilities = capabilities.where(
          'LOWER(capability) LIKE LOWER(?) OR LOWER(service) LIKE LOWER(?)',
          "%#{search}%"
        )
      end
      capabilities
    end
  end

  class OperatorServiceOnlyQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::OperatorServiceType], null: false

    def resolve(search:)
      operators = OperatorService.select(:name).distinct
      unless search.blank?
        operators = operators.where(
          'LOWER(capability) LIKE LOWER(?) OR LOWER(service) LIKE LOWER(?)',
          "%#{search}%"
        )
      end
      operators
    end
  end

  class OperatorServicesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :operators, [String], required: false, default_value: []
    argument :operator_ids, [Integer], required: false, default_value: []

    type [Types::OperatorServiceType], null: false

    def resolve(search:, operators:, operator_ids:)
      operator_data = OperatorService.order(name: :asc, service: :asc)
      operator_data = operator_data.name_contains(search) unless search.blank?

      operator_data = operator_data.where(id: operator_ids) unless operator_ids.empty?

      filtered_operators = operators.reject { |x| x.nil? || x.empty? }
      operator_data = operator_data.where(name: filtered_operators) unless filtered_operators.empty?
      operator_data
    end
  end
end
