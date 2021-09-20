# stylesheets_controller.rb
class StylesheetsController < ApplicationController
  caches_page :show # magic happens here
  acts_as_token_authentication_handler_for User, only: [:show]

  def show
    @stylesheet = Stylesheet.find_by(portal: params[:id])
    @stylesheet_contents = ""

    render(css: @stylesheet_contents, content_type: 'text/css')
  end

  # Remember to expire the cache when the stylesheet changes
end
