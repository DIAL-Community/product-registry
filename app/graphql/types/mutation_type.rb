module Types
  class MutationType < Types::BaseObject
    field :create_page, mutation: Mutations::CreatePage
    field :register_user, mutation: Mutations::RegisterUser
    field :sign_in, mutation: Mutations::SignIn
    #field :sign_out, mutation: Mutations::SignOut
  end
end
