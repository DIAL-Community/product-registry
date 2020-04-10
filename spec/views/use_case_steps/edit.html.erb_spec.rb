require 'rails_helper'

RSpec.describe "use_case_steps/edit", type: :view do
  before(:each) do
    @use_case_step = assign(:use_case_step, UseCaseStep.create!(
      :name => "MyString",
      :slug => "MyString",
      :step_number => 1,
      :use_case_id => ""
    ))
  end

  it "renders the edit use_case_step form" do
    render

    assert_select "form[action=?][method=?]", use_case_step_path(@use_case_step), "post" do

      assert_select "input[name=?]", "use_case_step[name]"

      assert_select "input[name=?]", "use_case_step[slug]"

      assert_select "input[name=?]", "use_case_step[step_number]"

      assert_select "input[name=?]", "use_case_step[use_case_id]"
    end
  end
end
