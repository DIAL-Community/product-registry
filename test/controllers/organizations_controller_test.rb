require 'test_helper'

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, role: :admin)
    @organization = organizations(:one)
  end

  test "should get index" do
    get organizations_url
    assert_response :success
  end

  test "search test" do
    get organizations_url(:search=>"Organization1")
    assert_equal(1, assigns(:organizations).count)

    get organizations_url(:search=>"InvalidOrg")
    assert_equal(0, assigns(:organizations).count)
  end

  test "should get new" do
    get new_organization_url
    assert_response :success
  end

  test "should create organization" do
    assert_difference('Organization.count') do
      post organizations_url, params: { organization: { is_endorser: @organization.is_endorser, name: @organization.name, slug: 'testslug', website: @organization.website, when_endorsed: '11/16/2018' } }
    end

    assert_redirected_to organization_url(Organization.last)
  end

  test "should show organization" do
    get organization_url(@organization)
    assert_response :success
  end

  test "should get edit" do
    get edit_organization_url(@organization)
    assert_response :success
  end

  test "should update organization" do
    patch organization_url(@organization), params: { organization: { is_endorser: @organization.is_endorser, name: @organization.name, slug: @organization.slug, website: @organization.website, when_endorsed: '11/16/2018' } }
    assert_redirected_to organization_url(@organization)
  end

  test "should destroy organization" do
    assert_difference('Organization.count', -1) do
      delete organization_url(@organization)
    end

    assert_redirected_to organizations_url
  end

  test "Policy tests: should reject new, edit, update, delete actions for regular user. Should allow get" do
    sign_in FactoryBot.create(:user, email: 'nonadmin@digitalimpactalliance.org')

    get organization_url(@organization)
    assert_response :success
    
    get new_organization_url
    assert_response :redirect

    get edit_organization_url(@organization)
    assert_response :redirect    

    patch organization_url(@organization), params: { organization: { is_endorser: @organization.is_endorser, name: @organization.name, slug: @organization.slug, website: @organization.website, when_endorsed: '11/16/2018' } }
    assert_response :redirect  

    delete organization_url(@organization)
    assert_response :redirect
  end
end
