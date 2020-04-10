require 'rails_helper'

RSpec.describe "use_case_steps/index", type: :view do
  before(:each) do
    assign(:use_case_steps, [
      UseCaseStep.create!(
        :name => "Name",
        :slug => "Slug",
        :step_number => 2,
        :use_case_id => ""
      ),
      UseCaseStep.create!(
        :name => "Name",
        :slug => "Slug",
        :step_number => 2,
        :use_case_id => ""
      )
    ])
  end

  it "renders a list of use_case_steps" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
