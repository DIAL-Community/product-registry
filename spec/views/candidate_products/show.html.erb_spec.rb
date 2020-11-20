require 'rails_helper'

RSpec.describe "candidate_products/show", type: :view do
  before(:each) do
    @candidate_product = assign(:candidate_product, CandidateProduct.create!(
      slug: "Slug",
      name: "Name",
      website: "Website",
      repository: "Repository"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Slug/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Website/)
    expect(rendered).to match(/Repository/)
  end
end
