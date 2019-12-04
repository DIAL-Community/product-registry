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

  test "creating organization without logo should not fail" do
    post organizations_url, params: { organization: { name: "Some Name", slug: 'some_name', when_endorsed: '11/16/2018' }}
    created_organization = Organization.last

    assert_equal created_organization.name, "Some Name"
    assert_redirected_to organization_url(created_organization)
  end

  test "updating organization without logo should not fail" do
    patch organization_url(@organization), params: { organization: {name: "Some New Name" } }

    updated_organization = Organization.find(@organization.id)
    assert_equal updated_organization.name, "Some New Name"
    assert_redirected_to organization_url(updated_organization)
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

  test "should show organization with digit only slug" do
    digit_only_organization = organizations(:three)
    get organization_url(digit_only_organization)
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

  test 'should destroy org_user when destroying organization' do
    organization = organizations(:four)

    assert_equal(User.where(organization_id: organization.id).count, 0)

    fourth_user = users(:four)
    fourth_user.role = User.roles[:org_user]
    fourth_user.organization_id = organization.id
    fourth_user.save!

    assert_equal(User.where(organization_id: organization.id).count, 1)

    delete organization_url(organization)

    assert_redirected_to organizations_url
    assert_equal(User.where(organization_id: organization.id).count, 0)
    assert_equal(User.where(id: fourth_user.id).count, 0)
  end

  test 'should not destroy product_org_user when destroying organization' do
    organization = organizations(:four)

    assert_equal(User.where(organization_id: organization.id).count, 0)

    fourth_user = users(:four)
    fourth_user.role = User.roles[:org_product_user]
    fourth_user.products = [products(:one)]
    fourth_user.organization_id = organization.id
    fourth_user.save!

    assert_equal(User.where(organization_id: organization.id).count, 1)

    delete organization_url(organization)

    assert_redirected_to organizations_url
    assert_equal(User.where(organization_id: organization.id).count, 0)
    assert_equal(User.where(id: fourth_user.id).count, 1)
    updated_fourth_user = User.find(fourth_user.id)
    assert_nil(updated_fourth_user.organization_id)
  end

  test "should destroy project along with organization" do
    @project = projects(:one)
    assert_difference('Project.count', -1) do
      delete organization_url(@organization)
    end
  end

  test "should not destroy sectors when destroying organization" do
    @sector = sectors(:one)
    assert_difference('Sector.count', 0) do
      delete organization_url(@organization)
    end

    assert_redirected_to organizations_url
  end

  test "should not destroy products when destroying organization" do
    @product = products(:one)
    assert_difference('Product.count', 0) do
      delete organization_url(@organization)
    end

    assert_redirected_to organizations_url
  end

  test "should not destroy contact when destroying organization" do
    @contact = contacts(:one)
    assert_difference('Contact.count', 0) do
      delete organization_url(@organization)
    end

    assert_redirected_to organizations_url
  end

  test 'should filter products' do
    # With no filters, should load 5 products
    get organizations_url
    assert_equal(5, assigns(:organizations).count)

    first_sector = sectors(:one)
    first_organization = organizations(:one)
    first_organization.sectors.push(first_sector)
    first_organization.save

    # Sector filter: should return only the above org
    add_parameter = { 'filter_name': 'sectors', 'filter_value': first_sector.id, 'filter_label': first_sector.name }
    post '/add_filter', params: add_parameter

    get organizations_url
    assert_equal(1, assigns(:organizations).count)
    assert_equal(first_organization.name, assigns(:organizations)[0].name)

    remove_parameter = { 'filter_array': { '0' => { filter_name: 'sectors' } } }
    post '/remove_filter', params: remove_parameter

    get organizations_url
    assert_equal(5, assigns(:organizations).count)

    first_location = locations(:one)
    second_organization = organizations(:two)
    second_organization.locations.push(first_location)
    second_organization.save

    add_parameter = { 'filter_name': 'countries', 'filter_value': first_location.id, 'filter_label': first_location.name }
    post '/add_filter', params: add_parameter

    # Country filter: should return only the above org
    get organizations_url
    assert_equal(1, assigns(:organizations).count)
    assert_equal(second_organization.name, assigns(:organizations)[0].name)

    # Combination assessment with origins:
    # * should return 3 products
    add_parameter = { 'filter_name': 'sectors', 'filter_value': first_sector.id, 'filter_label': first_sector.name }
    post '/add_filter', params: add_parameter

    get organizations_url
    assert_equal(0, assigns(:organizations).count)

    remove_parameter = { filter_array: { '0' => { filter_name: 'sectors' } } }
    post '/remove_filter', params: remove_parameter

    get organizations_url
    assert_equal(1, assigns(:organizations).count)

    remove_parameter = { filter_array: { '0' => { filter_name: 'countries' } } }
    post '/remove_filter', params: remove_parameter

    get organizations_url
    assert_equal(5, assigns(:organizations).count)
  end

  test 'Policy test: should reject edit for organization user' do
    organization = organizations(:four)
    sign_in FactoryBot.create(:user, email: 'user@fourth-organization.com', organization_id: organization.id)

    get organization_url(organization)
    assert_response :success
    assert_equal(0, assigns(:organization).locations.length)

    # Should be able to go to edit page for the organization
    get edit_organization_url(organization)
    assert_response :success

    # Should not be able to go to edit page for other organization.
    get edit_organization_url(organizations(:two))
    assert_response :redirect

    assert_equal(organization.is_endorser, true)

    location = locations(:one)

    patch_params = { organization: {
      is_endorser: false,
      name: 'Some random new name',
      website: 'some-fancy-website.com',
      when_endorsed: '11/16/2018'
    }, selected_countries: {
      "#{location.id}": location.id
    } }

    patch(organization_url(organization), params: patch_params)
    get organization_url(organization)

    # Patching should not update is_endorser, website and year.
    assert_not_equal(false, assigns(:organization).is_endorser)
    assert_not_equal('some-fancy-website.com', assigns(:organization).website)
    assert_not_equal(2018, assigns(:organization).when_endorsed.year)

    assert_equal(true, assigns(:organization).is_endorser)
    assert_equal('Some random new name', assigns(:organization).name)
    assert_equal('fourth-organization.com', assigns(:organization).website)
    assert_equal(2019, assigns(:organization).when_endorsed.year)

    # Should be able to edit the rest of the fields.
    assert_equal(1, assigns(:organization).locations.length)

    sign_in FactoryBot.create(:user, email: 'some-admin@digitalimpactalliance.org', role: :admin)

    patch(organization_url(organization), params: patch_params)
    get organization_url(organization)

    # Patching should not update is_endorser, name, website and year.
    assert_equal(false, assigns(:organization).is_endorser)
    assert_equal('Some random new name', assigns(:organization).name)
    assert_equal('some-fancy-website.com', assigns(:organization).website)
    assert_equal(2018, assigns(:organization).when_endorsed.year)
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
