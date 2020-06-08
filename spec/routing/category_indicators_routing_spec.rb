require "rails_helper"

RSpec.describe CategoryIndicatorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/category_indicators").to route_to("category_indicators#index")
    end

    it "routes to #new" do
      expect(get: "/category_indicators/new").to route_to("category_indicators#new")
    end

    it "routes to #show" do
      expect(get: "/category_indicators/1").to route_to("category_indicators#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/category_indicators/1/edit").to route_to("category_indicators#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/category_indicators").to route_to("category_indicators#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/category_indicators/1").to route_to("category_indicators#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/category_indicators/1").to route_to("category_indicators#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/category_indicators/1").to route_to("category_indicators#destroy", id: "1")
    end
  end
end
