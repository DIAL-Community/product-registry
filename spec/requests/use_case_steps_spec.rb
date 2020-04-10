require 'rails_helper'

RSpec.describe "UseCaseSteps", type: :request do
  describe "GET /use_case_steps" do
    it "works! (now write some real specs)" do
      get use_case_steps_path
      expect(response).to have_http_status(200)
    end
  end
end
