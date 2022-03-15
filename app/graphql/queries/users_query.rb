module Queries
  class UsersQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::UserType], null: false

    def resolve(search:)
      unless search.blank?
        use_cases = use_cases.name_contains(search)
      end
      use_cases
    end
  end

  class UserQuery < Queries::BaseQuery
    argument :user_id, String, required: true
    type Types::UserType, null: false

    def resolve(user_id:)
      user = User.find(user_id)

      user
    end
  end

  class SearchUsersQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    type Types::UserType.connection_type, null: false

    def resolve(search:)
      users = User.order(:email)
      unless search.blank?
        users = users.name_contains(search)
      end

      users.distinct
    end
  end

end
