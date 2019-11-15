module DeploysHelper
    def getDataFromProvider(method, url, provider, auth_token)
        if (provider == 'DO')
            uri = URI.parse(url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            case method
            when "GET"
                request = Net::HTTP::Get.new(uri.request_uri)
            when "POST"
                request = Net::HTTP::Post.new(uri.request_uri)
            when "DELETE" 
                request = Net::HTTP::Delete.new(uri.request_uri)   
            end
            
            request["Authorization"] = "Bearer "+auth_token
            request["Content-Type"] = "application/json"

            response = http.request(request)
    
            return response
          end
    end

    def getDataFromJenkins(method, url)
      jenkinsUrl = Rails.application.secrets.jenkins_url
      jenkinsUser = Rails.application.secrets.jenkins_user
      jenkinsPassword = Rails.application.secrets.jenkins_password

      # Latest version of Jenkins fails on crumb authentication, so pulling it out for now
      # Try again when Jenkins updates/fixes the issue
      # Will need to re-enable CSRF in Jenkins
      #crumb = getCrumb(jenkinsUrl, jenkinsUser, jenkinsPassword)

      uri = URI.parse(jenkinsUrl+url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = uri.scheme == 'https'
      case method
      when "GET"
          request = Net::HTTP::Get.new(uri.request_uri)
      when "POST"
          request = Net::HTTP::Post.new(uri.request_uri)
      end
      request["Authorization"] = "Basic " + Base64.encode64(jenkinsUser + ":" + jenkinsPassword).chomp
      # Latest version of Jenkins fails on crumb authentication, so pulling it out for now
      # Try again when Jenkins updates/fixes the issue
      #request["Jenkins-Crumb"] = crumb

      response = https.request(request)
  end

  def getCrumb(jenkinsUrl, jenkinsUser, jenkinsPassword) 

      crumbUrl = jenkinsUrl+"/crumbIssuer/api/json"
      uri = URI.parse(crumbUrl)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = uri.scheme == 'https'
      request = Net::HTTP::Get.new(URI(crumbUrl))
      request["Authorization"] = "Basic " + Base64.encode64(jenkinsUser + ":" + jenkinsPassword).chomp

      response = https.request(request)
      responseData = JSON.parse(response.body, object_class: OpenStruct)
      jenkinsCrumb = responseData.crumb
      
      return jenkinsCrumb
  end

    def jenkinsDeleteMachine(instanceName)

        buildUrl="/job/dockermachine/buildWithParameters?MACHINE_NAME="+instanceName;

        response = getDataFromJenkins("POST", buildUrl)
    end

    def jenkinsAddSshUser(instanceName, publicKey)
        buildUrl="/job/SetupSshUser/buildWithParameters?ENV_NAME="+instanceName+"&PUBLIC_KEY="+publicKey;

        response = getDataFromJenkins("POST", buildUrl)
    end

    def queryJenkinsJob(jobName, jobNumber)

        jobUrl = "/job/"+jobName+"/"+jobNumber.to_s+"/api/json";

        response = getDataFromJenkins("GET", jobUrl)
        responseData = JSON.parse(response.body, object_class: OpenStruct)

        return responseData.result;
    end

    def getJenkinsMessage(jobName, jobNumber, numLines)
        jobUrl="/job/"+jobName+"/"+jobNumber.to_s+"/logText/progressiveText?start=0"
        response = getDataFromJenkins("GET", jobUrl)
        responseData = response.body
        messageLines = responseData.strip.split("\n")
        if (numLines > 0)
            messageLines = messageLines.pop(numLines)
        end

        return messageLines
    end

    def getMachineInfo(instanceName, provider, authToken)
        machineName = instanceName
        ipAddress = "0.0.0.0"
        port = "80"
        response = getDataFromProvider("GET", 'https://api.digitalocean.com/v2/droplets/?tag_name=t4dlaunched', provider, authToken)
        if (response.code == "200")
            responseData = JSON.parse(response.body, object_class: OpenStruct)
            responseData.droplets.each do | droplet |
                puts droplet
                if (droplet.name == machineName) 
                    ipAddress = droplet.networks.v4[0].ip_address
                end
            end
        end
    
        return ipAddress
    end
end
