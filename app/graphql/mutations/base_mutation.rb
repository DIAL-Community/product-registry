# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    null true

    field_class Types::BaseField
    object_class Types::BaseObject

    def ready?(**_args)
      # Called with mutation args.
      # Use keyword args such as employee_id: or **args to collect them
      true
    end

    def an_admin
      if !context[:current_user].nil? && context[:current_user].roles.include?('admin')
        # Return true to continue the mutation:
        true
      else
        false
        # raise GraphQL::ExecutionError, "Only admins can run this mutation"
      end
    end

    def a_product_owner(product_id)
      if !context[:current_user].nil? && context[:current_user].user_products.include?(product_id)
        true
      else
        false
      end
    end

    def an_org_owner(organization_id)
      if !context[:current_user].nil? && context[:current_user].organization_id.equal?(organization_id)
        true
      else
        false
      end
    end

    def a_content_editor
      if !context[:current_user].nil? && context[:current_user].roles.include?('content_editor')
        true
      else
        false
      end
    end
  end
end
