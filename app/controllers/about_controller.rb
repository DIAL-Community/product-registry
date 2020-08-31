class AboutController < ApplicationController
  def cookies
  end

  def index
    stylesheet = Stylesheet.where(portal: session[:portal]['slug']).first
    @about_page = stylesheet.about_page
    @footer = stylesheet.footer_content
  end

  def privacy
  end

  def terms
  end

  def healthcheck
    sys_command = "PGPASSWORD='"+ENV['DATABASE_PASSWORD']+"' psql -h "+ENV['DATABASE_HOST']+" -U "+ENV['DATABASE_USER']+" -d "+ENV['DATABASE_NAME']+" -p "+ENV['DATABASE_PORT']+" -c '\\q'"

    db_health = system(sys_command)

    render json: {"health": db_health}
  end

end
