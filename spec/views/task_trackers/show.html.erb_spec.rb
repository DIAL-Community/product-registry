require 'rails_helper'

RSpec.describe "task_trackers/show", type: :view do
  before(:each) do
    @task_tracker = assign(:task_tracker, TaskTracker.create!(
      name: "Name",
      slug: "Slug"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Slug/)
  end
end
