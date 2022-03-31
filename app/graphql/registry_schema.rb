# frozen_string_literal: true

class RegistrySchema < GraphQL::Schema
  max_depth(13)

  mutation(Types::MutationType)
  query(Types::QueryType)
end
