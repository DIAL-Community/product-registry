# frozen_string_literal: true

module Queries
  class BaseQuery < GraphQL::Schema::Resolver
    def an_admin
      if !context[:current_user].nil? && context[:current_user].roles.include?('admin')
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
