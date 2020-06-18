require "rails_helper"

RSpec.describe RubricCategoriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/rubric_categories").to route_to("rubric_categories#index")
    end

    it "routes to #new" do
      expect(get: "/rubric_categories/new").to route_to("rubric_categories#new")
    end

    it "routes to #show" do
      expect(get: "/rubric_categories/1").to route_to("rubric_categories#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/rubric_categories/1/edit").to route_to("rubric_categories#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/rubric_categories").to route_to("rubric_categories#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/rubric_categories/1").to route_to("rubric_categories#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/rubric_categories/1").to route_to("rubric_categories#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/rubric_categories/1").to route_to("rubric_categories#destroy", id: "1")
    end
  end
end
