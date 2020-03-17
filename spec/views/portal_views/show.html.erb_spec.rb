require 'rails_helper'

RSpec.describe "portal_views/show", type: :view do
  before(:each) do
    @portal_view = assign(:portal_view, PortalView.create!(
      :name => "Name",
      :description => "Description",
      :top_nav => "Top Nav",
      :filter_nav => "Filter Nav",
      :user_roles => "User Roles",
      :product_view => "Product View",
      :organization_view => "Organization View"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Top Nav/)
    expect(rendered).to match(/Filter Nav/)
    expect(rendered).to match(/User Roles/)
    expect(rendered).to match(/Product View/)
    expect(rendered).to match(/Organization View/)
  end
end
