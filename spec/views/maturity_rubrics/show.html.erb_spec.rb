require 'rails_helper'

RSpec.describe "maturity_rubrics/show", type: :view do
  before(:each) do
    @maturity_rubric = assign(:maturity_rubric, MaturityRubric.create!(
      name: "Name",
      slug: "Slug"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Slug/)
  end
end
