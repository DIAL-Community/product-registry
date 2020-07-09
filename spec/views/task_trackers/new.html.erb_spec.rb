require 'rails_helper'

RSpec.describe "task_trackers/new", type: :view do
  before(:each) do
    assign(:task_tracker, TaskTracker.new(
      name: "MyString",
      slug: "MyString"
    ))
  end

  it "renders new task_tracker form" do
    render

    assert_select "form[action=?][method=?]", task_trackers_path, "post" do

      assert_select "input[name=?]", "task_tracker[name]"

      assert_select "input[name=?]", "task_tracker[slug]"
    end
  end
end
