require 'rails_helper'

RSpec.describe "category_indicators/edit", type: :view do
  before(:each) do
    @category_indicator = assign(:category_indicator, CategoryIndicator.create!(
      name: "MyString",
      slug: "MyString",
      weight: "9.99"
    ))
  end

  it "renders the edit category_indicator form" do
    render

    assert_select "form[action=?][method=?]", category_indicator_path(@category_indicator), "post" do

      assert_select "input[name=?]", "category_indicator[name]"

      assert_select "input[name=?]", "category_indicator[slug]"

      assert_select "input[name=?]", "category_indicator[weight]"
    end
  end
end
