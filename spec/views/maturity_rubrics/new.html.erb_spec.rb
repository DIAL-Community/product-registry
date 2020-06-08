require 'rails_helper'

RSpec.describe "maturity_rubrics/new", type: :view do
  before(:each) do
    assign(:maturity_rubric, MaturityRubric.new(
      name: "MyString",
      slug: "MyString"
    ))
  end

  it "renders new maturity_rubric form" do
    render

    assert_select "form[action=?][method=?]", maturity_rubrics_path, "post" do

      assert_select "input[name=?]", "maturity_rubric[name]"

      assert_select "input[name=?]", "maturity_rubric[slug]"
    end
  end
end
