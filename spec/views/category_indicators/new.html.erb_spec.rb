require 'rails_helper'

RSpec.describe "category_indicators/new", type: :view do
  before(:each) do
    assign(:category_indicator, CategoryIndicator.new(
      name: "MyString",
      slug: "MyString",
      weight: "9.99"
    ))
  end

  it "renders new category_indicator form" do
    render

    assert_select "form[action=?][method=?]", category_indicators_path, "post" do

      assert_select "input[name=?]", "category_indicator[name]"

      assert_select "input[name=?]", "category_indicator[slug]"

      assert_select "input[name=?]", "category_indicator[weight]"
    end
  end
end
