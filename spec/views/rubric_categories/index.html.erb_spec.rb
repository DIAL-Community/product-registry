require 'rails_helper'

RSpec.describe "rubric_categories/index", type: :view do
  before(:each) do
    assign(:rubric_categories, [
      RubricCategory.create!(
        name: "Name",
        slug: "Slug",
        weight: "9.99"
      ),
      RubricCategory.create!(
        name: "Name",
        slug: "Slug",
        weight: "9.99"
      )
    ])
  end

  it "renders a list of rubric_categories" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Slug".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
  end
end
