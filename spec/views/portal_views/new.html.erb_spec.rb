require 'rails_helper'

RSpec.describe "portal_views/new", type: :view do
  before(:each) do
    assign(:portal_view, PortalView.new(
      :name => "MyString",
      :description => "MyString",
      :top_nav => "MyString",
      :filter_nav => "MyString",
      :user_roles => "MyString",
      :product_view => "MyString",
      :organization_view => "MyString"
    ))
  end

  it "renders new portal_view form" do
    render

    assert_select "form[action=?][method=?]", portal_views_path, "post" do

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
