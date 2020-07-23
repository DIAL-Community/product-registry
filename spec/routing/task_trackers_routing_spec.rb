require "rails_helper"

RSpec.describe TaskTrackersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/task_trackers").to route_to("task_trackers#index")
    end

    it "routes to #new" do
      expect(get: "/task_trackers/new").to route_to("task_trackers#new")
    end

    it "routes to #show" do
      expect(get: "/task_trackers/1").to route_to("task_trackers#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/task_trackers/1/edit").to route_to("task_trackers#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/task_trackers").to route_to("task_trackers#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/task_trackers/1").to route_to("task_trackers#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/task_trackers/1").to route_to("task_trackers#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/task_trackers/1").to route_to("task_trackers#destroy", id: "1")
    end
  end
end
