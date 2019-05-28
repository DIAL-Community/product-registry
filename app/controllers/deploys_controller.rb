class DeploysController < ApplicationController
  # GET /deploys
  # GET /deploys.json
  def index
    if params[:auth_token]
      session[:auth_token] = params[:auth_token]
      session[:provider] = params[:provider]

      dropletData = helpers.getDataFromProvider("GET", 'https://api.digitalocean.com/v2/droplets', session[:provider], session[:auth_token])

      if (dropletData.droplets)
        @deploys = dropletData.droplets
      else
        @deploys = []
        @message = "Unable to load data. Please check your authentication token."
      end
    else
      @deploys = []
    end
  end

  def show
    if (params[:id])
      dropletData = helpers.getDataFromProvider("GET", 'https://api.digitalocean.com/v2/droplets/'+params[:id], session[:provider], session[:auth_token])
      logger.debug dropletData
      @deploy = dropletData.droplet
    end
  end

  def destroy
    if (params[:id])
      logger.debug "ID: " + params[:id]
      dropletData = helpers.getDataFromProvider("DELETE", 'https://api.digitalocean.com/v2/droplets/'+params[:id], session[:provider], session[:auth_token])
    end

    respond_to do |format|
      format.html { redirect_to deploys_url(:auth_token => session[:auth_token], :provider => session[:provider]), notice: 'Droplet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
