require 'rails_helper'

RSpec.describe "candidate_roles/index", type: :view do
  before(:each) do
    assign(:candidate_roles, [
      CandidateRole.create!(
        email: "Email",
        roles: "Roles",
        rejected: false,
        rejected_by: nil,
        approved_by: nil
      ),
      CandidateRole.create!(
        email: "Email",
        roles: "Roles",
        rejected: false,
        rejected_by: nil,
        approved_by: nil
      )
    ])
  end

  it "renders a list of candidate_roles" do
    render
    assert_select "tr>td", text: "Email".to_s, count: 2
    assert_select "tr>td", text: "Roles".to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
