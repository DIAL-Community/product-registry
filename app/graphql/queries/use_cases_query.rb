module Queries
  class UseCasesQuery < Queries::BaseQuery

    type [Types::UseCaseType], null: false

    def resolve
      UseCase.all.order(:slug)
    end
  end
end