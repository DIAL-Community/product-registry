require 'rails_helper'

RSpec.describe "use_case_steps/show", type: :view do
  before(:each) do
    @use_case_step = assign(:use_case_step, UseCaseStep.create!(
      :name => "Name",
      :slug => "Slug",
      :step_number => 2,
      :use_case_id => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Slug/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
  end
end
