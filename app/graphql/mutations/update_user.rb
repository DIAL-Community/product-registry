# frozen_string_literal: true

module Mutations
  class UpdateUser < Mutations::BaseMutation
    graphql_name 'CreateUser'

    argument :email, String, required: true
    argument :roles, GraphQL::Types::JSON, required: false, default_value: []
    argument :username, String, required: true
    argument :organizations, GraphQL::Types::JSON, required: true, default_value: []
    argument :products, GraphQL::Types::JSON, required: false, default_value: []

    field :user, Types::UserType, null: false
    field :errors, [String], null: false

    def resolve(email:, roles:, username:, organizations:, products:)
      user = User.find_by(email: email)
      if user.nil?
        {
          user: nil,
          errors: 'User not found'
        }
      end

      user.username = username
      user.roles = roles

      if !organizations.nil? && !organizations.empty?
        org = Organization.find_by(slug: organizations[0]['slug'])
        user.organization_id = org.id
      else
        user.organization_id = nil
      end

      user.products = []
      if !products.nil? && !products.empty?
        products.each do |prod|
          curr_prod = Product.find_by(slug: prod['slug'])
          user.products << curr_prod
        end
      end

      if user.save
        { user: user,
          success: user.persisted?,
          errors: user.errors }
      end
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{e.record.class.name}: " \
        "#{e.record.errors.full_messages.join(', ')}"
      )
    end
  end
end
