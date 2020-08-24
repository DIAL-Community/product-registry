module Mutations
  class SignIn < Mutations::BaseMutation
    graphql_name "SignIn"

    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: false
    field :token, String, null: false

    def resolve(args)
      user = User.find_for_database_authentication(email: args[:email])

      if user.present?
        if user.valid_password?(args[:password])
          context[:current_user] = user
          
          user.regenerate_authentication_token
          token = user.authentication_token #crypt.encrypt_and_sign("user-id:#{ user.id }")
          { user: user, token: token }
        else
          GraphQL::ExecutionError.new("Incorrect Email/Password")
        end
      else
        GraphQL::ExecutionError.new("User not registered on this application")
      end
    end
  end
end