# frozen_string_literal: true

module DeploysHelper
  def fetch_data_from_provider(method, url, provider, auth_token)
    if provider == 'DO'
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      case method
      when 'GET'
        request = Net::HTTP::Get.new(uri.request_uri)
      when 'POST'
        request = Net::HTTP::Post.new(uri.request_uri)
      when 'DELETE'
        request = Net::HTTP::Delete.new(uri.request_uri)
      end

      request['Authorization'] = "Bearer #{auth_token}"
      request['Content-Type'] = 'application/json'

      http.request(request)

    end
  end

  def fetch_data_from_jenkins(method, url)
    jenkins_url = Rails.application.secrets.jenkins_url
    jenkins_user = Rails.application.secrets.jenkins_user
    jenkins_password = Rails.application.secrets.jenkins_password

    # Latest version of Jenkins fails on crumb authentication, so pulling it out for now
    # Try again when Jenkins updates/fixes the issue
    # Will need to re-enable CSRF in Jenkins
    # crumb = fetch_crumb(jenkins_url, jenkins_user, jenkins_password)

    uri = URI.parse(jenkins_url + url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = uri.scheme == 'https'
    case method
    when 'GET'
      request = Net::HTTP::Get.new(uri.request_uri)
    when 'POST'
      request = Net::HTTP::Post.new(uri.request_uri)
    end
    request['Authorization'] = "Basic #{Base64.encode64("#{jenkins_user}:#{jenkins_password}").chomp}"
    # Latest version of Jenkins fails on crumb authentication, so pulling it out for now
    # Try again when Jenkins updates/fixes the issue
    # request["Jenkins-Crumb"] = crumb

    https.request(request)
  end

  def fetch_crumb(jenkins_url, jenkins_user, jenkins_password)
    crumb_url = "#{jenkins_url}/crumbIssuer/api/json"
    uri = URI.parse(crumb_url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = uri.scheme == 'https'
    request = Net::HTTP::Get.new(URI(crumb_url))
    request['Authorization'] = "Basic #{Base64.encode64("#{jenkins_user}:#{jenkins_password}").chomp}"

    response = https.request(request)
    response_data = JSON.parse(response.body, object_class: OpenStruct)
    response_data.crumb
  end

  def jenkins_delete_machine(instance_name)
    build_url = "/job/dockermachine/buildWithParameters?MACHINE_NAME=#{instance_name}"

    fetch_data_from_jenkins('POST', build_url)
  end

  def jenkins_add_ssh_user(instance_name, public_key)
    build_url = "/job/SetupSshUser/buildWithParameters?ENV_NAME=#{instance_name}&PUBLIC_KEY=#{public_key}"

    fetch_data_from_jenkins('POST', build_url)
  end

  def query_jenkins_job(job_name, job_number)
    job_url = "/job/#{job_name}/#{job_number}/api/json"

    response = fetch_data_from_jenkins('GET', job_url)
    response_data = JSON.parse(response.body, object_class: OpenStruct)

    response_data.result
  end

  def fetch_jenkins_message(job_name, job_number, num_lines)
    job_url = "/job/#{job_name}/#{job_number}/logText/progressiveText?start=0"
    response = fetch_data_from_jenkins('GET', job_url)
    response_data = response.body
    message_lines = response_data.strip.split("\n")
    message_lines = message_lines.pop(num_lines) if num_lines.positive?

    message_lines
  end

  def fetch_machine_info(instance_name, provider, auth_token)
    machine_name = instance_name
    ip_address = '0.0.0.0'
    response = fetch_data_from_provider('GET', 'https://api.digitalocean.com/v2/droplets/?tag_name=t4dlaunched',
                                        provider, auth_token)
    if response.code == '200'
      response_data = JSON.parse(response.body, object_class: OpenStruct)
      response_data.droplets.each do |droplet|
        puts droplet
        ip_address = droplet.networks.v4[0].ip_address if droplet.name == machine_name
      end
    end

    ip_address
  end
end
