require 'rails_helper'

RSpec.describe "category_indicators/index", type: :view do
  before(:each) do
    assign(:category_indicators, [
      CategoryIndicator.create!(
        name: "Name",
        slug: "Slug",
        weight: "9.99"
      ),
      CategoryIndicator.create!(
        name: "Name",
        slug: "Slug",
        weight: "9.99"
      )
    ])
  end

  it "renders a list of category_indicators" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Slug".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
  end
end
