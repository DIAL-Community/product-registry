# stylesheets_controller.rb
class StylesheetsController < ApplicationController
  caches_page :show # magic happens here

  def show
    @stylesheet = Stylesheet.find_by(portal: params[:id])
    @stylesheet_contents = "#header { background-color: " + @stylesheet.background_color + "; }\n#footer { background-color: " + @stylesheet.background_color + "; }"

    render css: @stylesheet_contents, content_type: 'text/css'
  end

  # Remember to expire the cache when the stylesheet changes
end