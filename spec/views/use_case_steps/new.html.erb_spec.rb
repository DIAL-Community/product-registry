require 'rails_helper'

RSpec.describe "use_case_steps/new", type: :view do
  before(:each) do
    assign(:use_case_step, UseCaseStep.new(
      :name => "MyString",
      :slug => "MyString",
      :step_number => 1,
      :use_case_id => ""
    ))
  end

  it "renders new use_case_step form" do
    render

    assert_select "form[action=?][method=?]", use_case_steps_path, "post" do

      assert_select "input[name=?]", "use_case_step[name]"

      assert_select "input[name=?]", "use_case_step[slug]"

      assert_select "input[name=?]", "use_case_step[step_number]"

      assert_select "input[name=?]", "use_case_step[use_case_id]"
    end
  end
end
