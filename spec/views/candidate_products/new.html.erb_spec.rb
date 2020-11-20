require 'rails_helper'

RSpec.describe "candidate_products/new", type: :view do
  before(:each) do
    assign(:candidate_product, CandidateProduct.new(
      slug: "MyString",
      name: "MyString",
      website: "MyString",
      repository: "MyString"
    ))
  end

  it "renders new candidate_product form" do
    render

    assert_select "form[action=?][method=?]", candidate_products_path, "post" do

      assert_select "input[name=?]", "candidate_product[slug]"

      assert_select "input[name=?]", "candidate_product[name]"

      assert_select "input[name=?]", "candidate_product[website]"

      assert_select "input[name=?]", "candidate_product[repository]"
    end
  end
end
