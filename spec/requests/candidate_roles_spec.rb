 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/candidate_roles", type: :request do
  # CandidateRole. As you add validations to CandidateRole, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      CandidateRole.create! valid_attributes
      get candidate_roles_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      candidate_role = CandidateRole.create! valid_attributes
      get candidate_role_url(candidate_role)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_candidate_role_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      candidate_role = CandidateRole.create! valid_attributes
      get edit_candidate_role_url(candidate_role)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new CandidateRole" do
        expect {
          post candidate_roles_url, params: { candidate_role: valid_attributes }
        }.to change(CandidateRole, :count).by(1)
      end

      it "redirects to the created candidate_role" do
        post candidate_roles_url, params: { candidate_role: valid_attributes }
        expect(response).to redirect_to(candidate_role_url(CandidateRole.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new CandidateRole" do
        expect {
          post candidate_roles_url, params: { candidate_role: invalid_attributes }
        }.to change(CandidateRole, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post candidate_roles_url, params: { candidate_role: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested candidate_role" do
        candidate_role = CandidateRole.create! valid_attributes
        patch candidate_role_url(candidate_role), params: { candidate_role: new_attributes }
        candidate_role.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the candidate_role" do
        candidate_role = CandidateRole.create! valid_attributes
        patch candidate_role_url(candidate_role), params: { candidate_role: new_attributes }
        candidate_role.reload
        expect(response).to redirect_to(candidate_role_url(candidate_role))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        candidate_role = CandidateRole.create! valid_attributes
        patch candidate_role_url(candidate_role), params: { candidate_role: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested candidate_role" do
      candidate_role = CandidateRole.create! valid_attributes
      expect {
        delete candidate_role_url(candidate_role)
      }.to change(CandidateRole, :count).by(-1)
    end

    it "redirects to the candidate_roles list" do
      candidate_role = CandidateRole.create! valid_attributes
      delete candidate_role_url(candidate_role)
      expect(response).to redirect_to(candidate_roles_url)
    end
  end
end
