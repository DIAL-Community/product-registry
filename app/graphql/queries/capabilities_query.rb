
module Queries
  class CapabilitiesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :capabilities, [String], required: false, default_value: []
    argument :services, [String], required: false, default_value: []
    type [Types::CapabilityType], null: false

    def resolve(search:, capabilities:, services:)
      capability_data = AggregatorCapability.order(service: :asc, capability: :asc)
      unless search.blank?
        capability_data = capability_data.name_contains(search)
      end

      filtered_capabilities = capabilities.reject { |x| x.nil? || x.empty? }
      unless filtered_capabilities.empty?
        capability_data = capability_data.where(capability: filtered_capabilities)
      end

      filtered_services = services.reject { |x| x.nil? || x.empty? }
      unless filtered_services.empty?
        capability_data = capability_data.where(service: filtered_services)
      end
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

    type [Types::OperatorServiceType], null: false

    def resolve(search:, operators:)
      operator_data = OperatorService.order(name: :asc, service: :asc)
      unless search.blank?
        operator_data = operator_data.name_contains(search)
      end

      filtered_operators = operators.reject { |x| x.nil? || x.empty? }
      unless filtered_operators.empty?
        operator_data = operator_data.where(name: filtered_operators)
      end
      operator_data
    end
  end
end
