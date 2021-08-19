module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    null true

    field_class Types::BaseField
    object_class Types::BaseObject
  end
end
