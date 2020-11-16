require "rails_helper"

RSpec.describe CandidateProductsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/candidate_products").to route_to("candidate_products#index")
    end

    it "routes to #new" do
      expect(get: "/candidate_products/new").to route_to("candidate_products#new")
    end

    it "routes to #show" do
      expect(get: "/candidate_products/1").to route_to("candidate_products#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/candidate_products/1/edit").to route_to("candidate_products#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/candidate_products").to route_to("candidate_products#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/candidate_products/1").to route_to("candidate_products#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/candidate_products/1").to route_to("candidate_products#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/candidate_products/1").to route_to("candidate_products#destroy", id: "1")
    end
  end
end
