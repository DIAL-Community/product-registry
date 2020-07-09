require 'rails_helper'

RSpec.describe "task_trackers/index", type: :view do
  before(:each) do
    assign(:task_trackers, [
      TaskTracker.create!(
        name: "Name",
        slug: "Slug"
      ),
      TaskTracker.create!(
        name: "Name",
        slug: "Slug"
      )
    ])
  end

  it "renders a list of task_trackers" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Slug".to_s, count: 2
  end
end
