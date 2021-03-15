module Queries
  class MeQuery < Queries::BaseQuery

    type Types::UserType, null: false

    def resolve
      if !context[:current_user].nil?
        User.find(context[:current_user].id)
      else
        user = User.new
        user.id = 0
        user
      end
    end
  end
end