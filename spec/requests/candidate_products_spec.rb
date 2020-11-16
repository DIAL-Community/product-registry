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

RSpec.describe "/candidate_products", type: :request do
  # CandidateProduct. As you add validations to CandidateProduct, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      CandidateProduct.create! valid_attributes
      get candidate_products_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      candidate_product = CandidateProduct.create! valid_attributes
      get candidate_product_url(candidate_product)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_candidate_product_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      candidate_product = CandidateProduct.create! valid_attributes
      get edit_candidate_product_url(candidate_product)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new CandidateProduct" do
        expect {
          post candidate_products_url, params: { candidate_product: valid_attributes }
        }.to change(CandidateProduct, :count).by(1)
      end

      it "redirects to the created candidate_product" do
        post candidate_products_url, params: { candidate_product: valid_attributes }
        expect(response).to redirect_to(candidate_product_url(CandidateProduct.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new CandidateProduct" do
        expect {
          post candidate_products_url, params: { candidate_product: invalid_attributes }
        }.to change(CandidateProduct, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post candidate_products_url, params: { candidate_product: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested candidate_product" do
        candidate_product = CandidateProduct.create! valid_attributes
        patch candidate_product_url(candidate_product), params: { candidate_product: new_attributes }
        candidate_product.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the candidate_product" do
        candidate_product = CandidateProduct.create! valid_attributes
        patch candidate_product_url(candidate_product), params: { candidate_product: new_attributes }
        candidate_product.reload
        expect(response).to redirect_to(candidate_product_url(candidate_product))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        candidate_product = CandidateProduct.create! valid_attributes
        patch candidate_product_url(candidate_product), params: { candidate_product: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested candidate_product" do
      candidate_product = CandidateProduct.create! valid_attributes
      expect {
        delete candidate_product_url(candidate_product)
      }.to change(CandidateProduct, :count).by(-1)
    end

    it "redirects to the candidate_products list" do
      candidate_product = CandidateProduct.create! valid_attributes
      delete candidate_product_url(candidate_product)
      expect(response).to redirect_to(candidate_products_url)
    end
  end
end
