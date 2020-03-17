require 'rails_helper'

RSpec.describe "portal_views/index", type: :view do
  before(:each) do
    assign(:portal_views, [
      PortalView.create!(
        :name => "Name",
        :description => "Description",
        :top_nav => "Top Nav",
        :filter_nav => "Filter Nav",
        :user_roles => "User Roles",
        :product_view => "Product View",
        :organization_view => "Organization View"
      ),
      PortalView.create!(
        :name => "Name",
        :description => "Description",
        :top_nav => "Top Nav",
        :filter_nav => "Filter Nav",
        :user_roles => "User Roles",
        :product_view => "Product View",
        :organization_view => "Organization View"
      )
    ])
  end

  it "renders a list of portal_views" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Top Nav".to_s, :count => 2
    assert_select "tr>td", :text => "Filter Nav".to_s, :count => 2
    assert_select "tr>td", :text => "User Roles".to_s, :count => 2
    assert_select "tr>td", :text => "Product View".to_s, :count => 2
    assert_select "tr>td", :text => "Organization View".to_s, :count => 2
  end
end
