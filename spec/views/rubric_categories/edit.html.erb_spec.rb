require 'rails_helper'

RSpec.describe "rubric_categories/edit", type: :view do
  before(:each) do
    @rubric_category = assign(:rubric_category, RubricCategory.create!(
      name: "MyString",
      slug: "MyString",
      weight: "9.99"
    ))
  end

  it "renders the edit rubric_category form" do
    render

    assert_select "form[action=?][method=?]", rubric_category_path(@rubric_category), "post" do

      assert_select "input[name=?]", "rubric_category[name]"

      assert_select "input[name=?]", "rubric_category[slug]"

      assert_select "input[name=?]", "rubric_category[weight]"
    end
  end
end
