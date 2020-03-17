require 'rails_helper'

RSpec.describe "portal_views/edit", type: :view do
  before(:each) do
    @portal_view = assign(:portal_view, PortalView.create!(
      :name => "MyString",
      :description => "MyString",
      :top_nav => "MyString",
      :filter_nav => "MyString",
      :user_roles => "MyString",
      :product_view => "MyString",
      :organization_view => "MyString"
    ))
  end

  it "renders the edit portal_view form" do
    render

    assert_select "form[action=?][method=?]", portal_view_path(@portal_view), "post" do

      assert_select "input[name=?]", "portal_view[name]"

      assert_select "input[name=?]", "portal_view[description]"

      assert_select "input[name=?]", "portal_view[top_nav]"

      assert_select "input[name=?]", "portal_view[filter_nav]"

      assert_select "input[name=?]", "portal_view[user_roles]"

      assert_select "input[name=?]", "portal_view[product_view]"

      assert_select "input[name=?]", "portal_view[organization_view]"
    end
  end
end
