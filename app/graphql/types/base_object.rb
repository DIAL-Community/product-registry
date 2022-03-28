# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    field_class Types::BaseField
    connection_type_class Types::BaseConnection

    def current_user
      context[:current_user]
    end
  end
end
