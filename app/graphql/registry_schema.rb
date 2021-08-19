class RegistrySchema < GraphQL::Schema
  max_depth(8)

  mutation(Types::MutationType)
  query(Types::QueryType)
end
