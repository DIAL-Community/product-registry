require "rails_helper"

RSpec.describe CandidateRolesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/candidate_roles").to route_to("candidate_roles#index")
    end

    it "routes to #new" do
      expect(get: "/candidate_roles/new").to route_to("candidate_roles#new")
    end

    it "routes to #show" do
      expect(get: "/candidate_roles/1").to route_to("candidate_roles#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/candidate_roles/1/edit").to route_to("candidate_roles#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/candidate_roles").to route_to("candidate_roles#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/candidate_roles/1").to route_to("candidate_roles#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/candidate_roles/1").to route_to("candidate_roles#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/candidate_roles/1").to route_to("candidate_roles#destroy", id: "1")
    end
  end
end
