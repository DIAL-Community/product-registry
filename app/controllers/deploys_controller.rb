class DeploysController < ApplicationController
  # GET /deploys
  # GET /deploys.json
  def index
    if params[:auth_token]
      session[:auth_token] = params[:auth_token]
      session[:provider] = params[:provider]

      response = helpers.getDataFromProvider("GET", 'https://api.digitalocean.com/v2/droplets/?tag_name=t4dlaunched', session[:provider], session[:auth_token])

      if (response.code == "200")
        responseData = JSON.parse(response.body, object_class: OpenStruct)
        @deploys = responseData.droplets
        if (@deploys.count == 0)
          @message = "No droplets found"
        end
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
      response = helpers.getDataFromProvider("GET", 'https://api.digitalocean.com/v2/droplets/'+params[:id], session[:provider], session[:auth_token])
      if (response.code == "200")
        responseData = JSON.parse(response.body, object_class: OpenStruct)
        @deploy = responseData.droplet
      end
    end
  end

  def destroy
    if (params[:id])
      # Get the name
      response = helpers.getDataFromProvider("GET", 'https://api.digitalocean.com/v2/droplets/'+params[:id], session[:provider], session[:auth_token])
      responseData = JSON.parse(response.body, object_class: OpenStruct)
      machine_name = responseData.droplet.name
      response = helpers.getDataFromProvider("DELETE", 'https://api.digitalocean.com/v2/droplets/'+params[:id], session[:provider], session[:auth_token])
      helpers.jenkinsDeleteMachine(machine_name)
    end

    respond_to do |format|
      format.html { redirect_to deploys_url(:auth_token => session[:auth_token], :provider => session[:provider]), notice: 'Droplet is successfully scheduled to be destroyed.' }
      format.json { head :no_content }
    end
  end
end
