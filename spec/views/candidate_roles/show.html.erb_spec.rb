require 'rails_helper'

RSpec.describe "candidate_roles/show", type: :view do
  before(:each) do
    @candidate_role = assign(:candidate_role, CandidateRole.create!(
      email: "Email",
      roles: "Roles",
      rejected: false,
      rejected_by: nil,
      approved_by: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Roles/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
