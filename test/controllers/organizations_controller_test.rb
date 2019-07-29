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
    get organizations_url(:search=>"Organization Again")
    assert_equal(1, assigns(:organizations).count)

    get organizations_url(:search=>"InvalidOrg")
    assert_equal(0, assigns(:organizations).count)
  end

  test "should get new" do
    get new_organization_url
    assert_response :success
  end

  test "should slug digits" do
    digit_org_name = "1234-56-789 011"
    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')
    post organizations_url, params: { organization: { name: digit_org_name, website: "aaa.com", when_endorsed: '11/16/2018' }, reslug: true, logo: uploaded_file }
    saved_organization = Organization.last;
    assert_equal saved_organization.slug, "123456789_011"

    digit_org_name = "1234 56 789 011"
    uploaded_file = fixture_file_upload('files/another-logo.png', 'image/png')
    post organizations_url, params: { organization: { name: digit_org_name, website: "aaa.com", when_endorsed: '11/16/2018' }, reslug: true, logo: uploaded_file }
    saved_organization = Organization.last;
    assert_equal saved_organization.slug, "1234_56_789_011"
  end

  test "should append counter to duplicate slugs" do
    digit_org_name = "ABCD 56 789 011"
    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')
    post organizations_url, params: { organization: { name: digit_org_name, website: "aaa.com", when_endorsed: '11/16/2018' }, reslug: true, logo: uploaded_file }
    saved_organization = Organization.last;
    assert_equal saved_organization.slug, "abcd_56_789_011"

    digit_org_name = "ABCD?$% 56 789 011"
    uploaded_file = fixture_file_upload('files/another-logo.png', 'image/png')
    post organizations_url, params: { organization: { name: digit_org_name, website: "aaa.com", when_endorsed: '11/16/2018' }, reslug: true, duplicate: true, logo: uploaded_file }
    saved_organization = Organization.last;
    assert_equal saved_organization.slug, "abcd_56_789_011_dup1"

    digit_org_name = "ABCD?$% 56 789 011"
    uploaded_file = fixture_file_upload('files/other-logo.png', 'image/png')
    post organizations_url, params: { organization: { name: digit_org_name, website: "aaa.com", when_endorsed: '11/16/2018' }, reslug: true, duplicate: true, logo: uploaded_file }
    saved_organization = Organization.last;
    assert_equal saved_organization.slug, "abcd_56_789_011_dup2"

    digit_org_name = "ABCD?$% 56 789 011"
    uploaded_file = fixture_file_upload('files/more-logo.png', 'image/png')
    post organizations_url, params: { organization: { name: digit_org_name, website: "aaa.com", when_endorsed: '11/16/2018' }, reslug: true, duplicate: true, logo: uploaded_file }
    saved_organization = Organization.last;
    assert_equal saved_organization.slug, "abcd_56_789_011_dup3"
  end

  test "should create organization" do
    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')
    assert_difference('Organization.count') do
      post organizations_url, params: { organization: { is_endorser: @organization.is_endorser, name: @organization.name, slug: 'testslug', website: @organization.website, when_endorsed: '11/16/2018' }, logo: uploaded_file }
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
    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')
    patch organization_url(@organization), params: { organization: { is_endorser: @organization.is_endorser, name: @organization.name, slug: @organization.slug, website: @organization.website, when_endorsed: '11/16/2018' }, logo: uploaded_file }
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
