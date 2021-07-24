module Modules
  module Discourse

    DISCOURSE_URL = 'https://hub.dial.community'
    PRODUCTS_CATEGORY = 68
    BB_CATEGORY = 69

    def create_discourse_topic(object, objType)
      discourse_uri = URI.parse(DISCOURSE_URL+'/posts.json')
      http = Net::HTTP.new(discourse_uri.host, discourse_uri.port)
      http.use_ssl = true

      objType == 'Building Blocks' ? category = BB_CATEGORY : category = PRODUCTS_CATEGORY
      
      request = Net::HTTP::Post.new(discourse_uri.path)
      request['Content-Type'] = 'application/json'
      request['Api-Key'] = ENV['DISCOURSE_KEY']
      request['Api-Username'] = 'system'
      request.body = { 'category' => category, 'tags' => [objType,object.slug, 'products'],'title' => 'Discussion on '+object.name, 'raw' => 'This forum is for open discussion on [' + object.name + '](https://solutions.dial.community/products/' + object.slug + ')' }.to_json

      response = http.request(request)
      response_json = JSON.parse(response.body)
      topic_id = response_json["topic_id"]
      return topic_id
    end
  end
end
