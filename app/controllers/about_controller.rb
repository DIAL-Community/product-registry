class AboutController < ApplicationController
  def cookies
  end

  def index
    stylesheet = Stylesheet.where(portal: session[:portal]['slug']).first
    @about_page = stylesheet.about_page
    @footer = stylesheet.footer_content
  end
end
