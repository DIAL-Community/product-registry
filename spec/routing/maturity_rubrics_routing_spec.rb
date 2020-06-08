require "rails_helper"

RSpec.describe MaturityRubricsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/maturity_rubrics").to route_to("maturity_rubrics#index")
    end

    it "routes to #new" do
      expect(get: "/maturity_rubrics/new").to route_to("maturity_rubrics#new")
    end

    it "routes to #show" do
      expect(get: "/maturity_rubrics/1").to route_to("maturity_rubrics#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/maturity_rubrics/1/edit").to route_to("maturity_rubrics#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/maturity_rubrics").to route_to("maturity_rubrics#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/maturity_rubrics/1").to route_to("maturity_rubrics#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/maturity_rubrics/1").to route_to("maturity_rubrics#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/maturity_rubrics/1").to route_to("maturity_rubrics#destroy", id: "1")
    end
  end
end
