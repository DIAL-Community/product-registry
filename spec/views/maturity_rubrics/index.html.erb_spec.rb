require 'rails_helper'

RSpec.describe "maturity_rubrics/index", type: :view do
  before(:each) do
    assign(:maturity_rubrics, [
      MaturityRubric.create!(
        name: "Name",
        slug: "Slug"
      ),
      MaturityRubric.create!(
        name: "Name",
        slug: "Slug"
      )
    ])
  end

  it "renders a list of maturity_rubrics" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Slug".to_s, count: 2
  end
end
