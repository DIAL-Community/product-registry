class DeploysController < ApplicationController
  before_action :set_deploy, only: [:show, :edit, :update, :destroy]
  before_action :set_list, only: [:index, :refresh_list]

  # GET /deploys
  # GET /deploys.json
  def index
  
  end

  def show
    errorMsg = helpers.getJenkinsMessage(@deploy.product.slug, @deploy.job_id, 5)
    @messages = errorMsg
    if (@deploy.status == "BUILDING")
    end
  end

  def refresh_list
    respond_to do |format|
      format.js
    end
  end

  def show_messages
    @deploy = Deploy.find(params[:deploy_id])
    @messages = helpers.getJenkinsMessage(@deploy.product.slug, @deploy.job_id, -1)
  end

  def add_ssh_user
    @deploy = Deploy.find(params[:deploy_id])
    helpers.jenkinsAddSshUser(@deploy.instance_name, params[:pub_key].gsub('+','%2B'))

    respond_to do |format|
      format.html { redirect_to deploys_url(:auth_token => session[:auth_token], :provider => session[:provider]), notice: 'SSH Key added for this machine.' }
      format.json { head :no_content }
    end
  end

  def create
    product = Product.where(slug: params[:jobName])[0]
    @deploy = Deploy.new
    @deploy.user_id = current_user.id
    @deploy.product_id = product.id
    @deploy.provider = params[:provider]
    @deploy.auth_token = params[:authToken]
    @deploy.job_id = params[:jobNumber];
    @deploy.instance_name = params[:orgId]+"-"+product.slug
    @deploy.status = "BUILDING";

    @deploy.save
  end

  def destroy
  
    helpers.jenkinsDeleteMachine(@deploy.instance_name)
    @deploy.destroy

    respond_to do |format|
      format.html { redirect_to deploys_url(:auth_token => session[:auth_token], :provider => session[:provider]), notice: 'Deploy has successfully been deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deploy
      @deploy = Deploy.find(params[:id])
      case @deploy.provider
      when "DO"
          @provider_full = "Digital Ocean"
      end
    end

    def set_list
      @deploys = Deploy.where(user_id: current_user.id)
        
    @deploys.each do |deploy|
      if (deploy.status == "BUILDING")
        # Query jenkins
        status = helpers.queryJenkinsJob(deploy.product.slug, deploy.job_id)
        if (status == "SUCCESS")
          deploy.status = "RUNNING"
          # Read the log data from Jenkins to get the machine info
          ipAddress= helpers.getMachineInfo(deploy.instance_name, deploy.provider, deploy.auth_token)
          # The product.default_url has the format - insert the correct IP address
          deploy.url = deploy.product.default_url.gsub('<host_ip>', ipAddress)
          if (deploy.url != "0.0.0.0") # If it comes back with this value, something went wrong - re-query
            # Save the deploy
            deploy.save
          end
        elsif (status != nil) 
          # If status is not nil or SUCCESS, then there is some kind of error
          deploy.status = "ERROR"
          errorMsg = helpers.getJenkinsMessage(deploy.product.slug, deploy.job_id, 3)
          deploy.message = errorMsg
          deploy.save
        end
      end
      if (deploy.status == "RUNNING")
      end
    end
    end
end
