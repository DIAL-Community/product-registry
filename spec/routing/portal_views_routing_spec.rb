require "rails_helper"

RSpec.describe PortalViewsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/portal_views").to route_to("portal_views#index")
    end

    it "routes to #new" do
      expect(:get => "/portal_views/new").to route_to("portal_views#new")
    end

    it "routes to #show" do
      expect(:get => "/portal_views/1").to route_to("portal_views#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/portal_views/1/edit").to route_to("portal_views#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/portal_views").to route_to("portal_views#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/portal_views/1").to route_to("portal_views#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/portal_views/1").to route_to("portal_views#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/portal_views/1").to route_to("portal_views#destroy", :id => "1")
    end
  end
end
