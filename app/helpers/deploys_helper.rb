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
end
