require 'rails_helper'

RSpec.describe "candidate_roles/new", type: :view do
  before(:each) do
    assign(:candidate_role, CandidateRole.new(
      email: "MyString",
      roles: "MyString",
      rejected: false,
      rejected_by: nil,
      approved_by: nil
    ))
  end

  it "renders new candidate_role form" do
    render

    assert_select "form[action=?][method=?]", candidate_roles_path, "post" do

      assert_select "input[name=?]", "candidate_role[email]"

      assert_select "input[name=?]", "candidate_role[roles]"

      assert_select "input[name=?]", "candidate_role[rejected]"

      assert_select "input[name=?]", "candidate_role[rejected_by_id]"

      assert_select "input[name=?]", "candidate_role[approved_by_id]"
    end
  end
end
