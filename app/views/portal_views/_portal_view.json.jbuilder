# frozen_string_literal: true

json.extract! portal_view, :id, :name, :description, :top_nav, :filter_nav, :user_roles, :product_view,
              :organization_view
json.url portal_view_url(portal_view, format: :json)
