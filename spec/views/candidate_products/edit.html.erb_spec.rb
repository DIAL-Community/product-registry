require 'rails_helper'

RSpec.describe "candidate_products/edit", type: :view do
  before(:each) do
    @candidate_product = assign(:candidate_product, CandidateProduct.create!(
      slug: "MyString",
      name: "MyString",
      website: "MyString",
      repository: "MyString"
    ))
  end

  it "renders the edit candidate_product form" do
    render

    assert_select "form[action=?][method=?]", candidate_product_path(@candidate_product), "post" do

      assert_select "input[name=?]", "candidate_product[slug]"

      assert_select "input[name=?]", "candidate_product[name]"

      assert_select "input[name=?]", "candidate_product[website]"

      assert_select "input[name=?]", "candidate_product[repository]"
    end
  end
end
