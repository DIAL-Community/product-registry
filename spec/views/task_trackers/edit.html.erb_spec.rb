require 'rails_helper'

RSpec.describe "task_trackers/edit", type: :view do
  before(:each) do
    @task_tracker = assign(:task_tracker, TaskTracker.create!(
      name: "MyString",
      slug: "MyString"
    ))
  end

  it "renders the edit task_tracker form" do
    render

    assert_select "form[action=?][method=?]", task_tracker_path(@task_tracker), "post" do

      assert_select "input[name=?]", "task_tracker[name]"

      assert_select "input[name=?]", "task_tracker[slug]"
    end
  end
end
