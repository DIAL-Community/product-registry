require 'rails_helper'

RSpec.describe "PortalViews", type: :request do
  describe "GET /portal_views" do
    it "works! (now write some real specs)" do
      get portal_views_path
      expect(response).to have_http_status(200)
    end
  end
end
