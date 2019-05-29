module DeploysHelper
    def getDataFromProvider(method, url, provider, auth_token)
        if (provider == 'Digital Ocean')
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

    def getCrumb(jenkinsUrl, jenkinsUser, jenkinsPassword) 

        crumbUrl = jenkinsUrl+"/crumbIssuer/api/json"
        uri = URI.parse(crumbUrl)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        request["Authorization"] = "Basic " + Base64.encode64(jenkinsUser + ":" + jenkinsPassword).chomp

        response = http.request(request)
        responseData = JSON.parse(response.body, object_class: OpenStruct)
        jenkinsCrumb = responseData.crumb
        
        return jenkinsCrumb
    end

    def jenkinsDeleteMachine(instanceName)
        
        jenkinsUrl = Rails.configuration.jenkins["jenkins_url"]
        jenkinsUser = Rails.configuration.jenkins["jenkins_user"]
        jenkinsPassword = Rails.configuration.jenkins["jenkins_password"]

        crumb = getCrumb(jenkinsUrl, jenkinsUser, jenkinsPassword)

        buildUrl=jenkinsUrl+"/job/dockermachine/buildWithParameters?MACHINE_NAME="+instanceName;
        uri = URI.parse(buildUrl)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri)
        request["Authorization"] = "Basic " + Base64.encode64(jenkinsUser + ":" + jenkinsPassword).chomp
        request["Jenkins-Crumb"] = crumb

        response = http.request(request)
    end
end
