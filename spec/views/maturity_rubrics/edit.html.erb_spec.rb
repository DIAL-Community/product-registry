require 'rails_helper'

RSpec.describe "maturity_rubrics/edit", type: :view do
  before(:each) do
    @maturity_rubric = assign(:maturity_rubric, MaturityRubric.create!(
      name: "MyString",
      slug: "MyString"
    ))
  end

  it "renders the edit maturity_rubric form" do
    render

    assert_select "form[action=?][method=?]", maturity_rubric_path(@maturity_rubric), "post" do

      assert_select "input[name=?]", "maturity_rubric[name]"

      assert_select "input[name=?]", "maturity_rubric[slug]"
    end
  end
end
