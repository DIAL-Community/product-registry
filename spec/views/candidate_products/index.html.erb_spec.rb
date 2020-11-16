require 'rails_helper'

RSpec.describe "candidate_products/index", type: :view do
  before(:each) do
    assign(:candidate_products, [
      CandidateProduct.create!(
        slug: "Slug",
        name: "Name",
        website: "Website",
        repository: "Repository"
      ),
      CandidateProduct.create!(
        slug: "Slug",
        name: "Name",
        website: "Website",
        repository: "Repository"
      )
    ])
  end

  it "renders a list of candidate_products" do
    render
    assert_select "tr>td", text: "Slug".to_s, count: 2
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Website".to_s, count: 2
    assert_select "tr>td", text: "Repository".to_s, count: 2
  end
end
