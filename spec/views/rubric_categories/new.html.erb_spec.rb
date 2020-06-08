require 'rails_helper'

RSpec.describe "rubric_categories/new", type: :view do
  before(:each) do
    assign(:rubric_category, RubricCategory.new(
      name: "MyString",
      slug: "MyString",
      weight: "9.99"
    ))
  end

  it "renders new rubric_category form" do
    render

    assert_select "form[action=?][method=?]", rubric_categories_path, "post" do

      assert_select "input[name=?]", "rubric_category[name]"

      assert_select "input[name=?]", "rubric_category[slug]"

      assert_select "input[name=?]", "rubric_category[weight]"
    end
  end
end
