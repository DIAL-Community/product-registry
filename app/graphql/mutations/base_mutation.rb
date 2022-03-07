module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    null true

    field_class Types::BaseField
    object_class Types::BaseObject

    def ready?(**args)
      # Called with mutation args.
      # Use keyword args such as employee_id: or **args to collect them
      true
    end

    def is_admin
      if !context[:current_user].nil? && context[:current_user].roles.include?('admin')
        # Return true to continue the mutation:
        true
      else
        false
        #raise GraphQL::ExecutionError, "Only admins can run this mutation"
      end
    end

    def is_product_owner
      if !context[:current_user].nil? 
        user = User.find(context[:current_user].id)
        puts "USER PRODUCTS: " + user.products.inspect
        # Return true to continue the mutation:
        true
      else
        raise GraphQL::ExecutionError, "Only product owners can run this mutation"
      end
    end
  end
end
