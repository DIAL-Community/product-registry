# frozen_string_literal: true

require 'test_helper'

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, roles: [:admin])
    @organization = organizations(:one)
  end

  test 'should get index' do
    get organizations_url
    assert_response :success
  end

  test 'search test' do
    get organizations_url(search: 'Organization Again')
    assert_equal(1, assigns(:organizations).count)

    get organizations_url(search: 'InvalidOrg')
    assert_equal(0, assigns(:organizations).count)
  end

  test 'should get new' do
    get new_organization_url
    assert_response :success
  end

  test 'creating organization without logo should not fail' do
    post organizations_url,
         params: { organization: { name: 'Some Name', slug: 'some_name', when_endorsed: '11/16/2018' } }
    created_organization = Organization.last

    assert_equal created_organization.name, 'Some Name'
    assert_redirected_to organization_url(created_organization)
  end

  test 'updating organization without logo should not fail' do
    patch organization_url(@organization), params: { organization: { name: 'Some New Name' } }

    updated_organization = Organization.find(@organization.id)
    assert_equal updated_organization.name, 'Some New Name'
    assert_redirected_to organization_url(updated_organization, locale: 'en')
  end

  test 'should slug digits' do
    digit_org_name = '1234-56-789 011'
    uploaded_file = fixture_file_upload('logo.png', 'image/png')
    post organizations_url,
         params: { organization: { name: digit_org_name, website: 'aaa.com', when_endorsed: '11/16/2018' },
                   reslug: true, logo: uploaded_file }
    saved_organization = Organization.last
    assert_equal saved_organization.slug, '123456789_011'

    digit_org_name = '1234 56 789 011'
    uploaded_file = fixture_file_upload('another-logo.png', 'image/png')
    post organizations_url,
         params: { organization: { name: digit_org_name, website: 'aaa.com', when_endorsed: '11/16/2018' },
                   reslug: true, logo: uploaded_file }
    saved_organization = Organization.last
    assert_equal saved_organization.slug, '1234_56_789_011'
  end

  test 'should append counter to duplicate slugs' do
    digit_org_name = 'ABCD 56 789 011'
    uploaded_file = fixture_file_upload('logo.png', 'image/png')
    post organizations_url,
         params: { organization: { name: digit_org_name, website: 'aaa.com', when_endorsed: '11/16/2018' },
                   reslug: true, logo: uploaded_file }
    saved_organization = Organization.last
    assert_equal saved_organization.slug, 'abcd_56_789_011'

    digit_org_name = 'ABCD?$% 56 789 011'
    uploaded_file = fixture_file_upload('another-logo.png', 'image/png')
    post organizations_url,
         params: { organization: { name: digit_org_name, website: 'aaa.com', when_endorsed: '11/16/2018' },
                   reslug: true, duplicate: true, logo: uploaded_file }
    saved_organization = Organization.last
    assert_equal saved_organization.slug, 'abcd_56_789_011_dup1'

    digit_org_name = 'ABCD?$% 56 789 011'
    uploaded_file = fixture_file_upload('other-logo.png', 'image/png')
    post organizations_url,
         params: { organization: { name: digit_org_name, website: 'aaa.com', when_endorsed: '11/16/2018' },
                   reslug: true, duplicate: true, logo: uploaded_file }
    saved_organization = Organization.last
    assert_equal saved_organization.slug, 'abcd_56_789_011_dup2'

    digit_org_name = 'ABCD?$% 56 789 011'
    uploaded_file = fixture_file_upload('more-logo.png', 'image/png')
    post organizations_url,
         params: { organization: { name: digit_org_name, website: 'aaa.com', when_endorsed: '11/16/2018' },
                   reslug: true, duplicate: true, logo: uploaded_file }
    saved_organization = Organization.last
    assert_equal saved_organization.slug, 'abcd_56_789_011_dup3'
  end

  test 'should create organization' do
    uploaded_file = fixture_file_upload('logo.png', 'image/png')
    assert_difference('Organization.count') do
      post organizations_url,
           params: { organization: { is_endorser: @organization.is_endorser, name: @organization.name,
                                     slug: 'testslug', website: @organization.website, when_endorsed: '11/16/2018' },
                     logo: uploaded_file }
    end

    assert_redirected_to organization_url(Organization.last)
  end

  test 'should show organization' do
    get organization_url(@organization)
    assert_response :success
  end

  test 'should show organization with digit only slug' do
    digit_only_organization = organizations(:three)
    get organization_url(digit_only_organization)
    assert_response :success
  end

  test 'should get edit' do
    get edit_organization_url(@organization)
    assert_response :success
  end

  test 'should update organization' do
    uploaded_file = fixture_file_upload('logo.png', 'image/png')
    patch organization_url(@organization),
          params: { organization: { is_endorser: @organization.is_endorser, name: @organization.name,
                                    slug: @organization.slug, website: @organization.website,
                                    when_endorsed: '11/16/2018' },
                    logo: uploaded_file }
    assert_redirected_to organization_url(@organization, locale: 'en')
  end

  test 'should destroy organization' do
    assert_difference('Organization.count', -1) do
      delete organization_url(@organization)
    end

    assert_redirected_to organizations_url
  end

  test 'should destroy org_user when destroying org' do
    organization = organizations(:four)

    assert_equal(User.where(organization_id: organization.id).count, 0)

    fourth_user = users(:four)
    fourth_user.roles = [User.user_roles[:org_user]]
    fourth_user.organization_id = organization.id
    fourth_user.save!

    assert_equal(User.where(organization_id: organization.id).count, 1)

    delete organization_url(organization)

    assert_redirected_to organizations_url
    assert_equal(User.where(organization_id: organization.id).count, 0)
    assert_equal(User.where(id: fourth_user.id).count, 0)
  end

  test 'should not destroy product_org_user when destroying org' do
    organization = organizations(:four)

    assert_equal(User.where(organization_id: organization.id).count, 0)

    fourth_user = users(:four)
    fourth_user.roles = [User.user_roles[:org_product_user]]
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

  test 'should destroy project along with organization' do
    @project = projects(:one)
    assert_difference('Project.count', -1) do
      delete organization_url(@organization)
    end
  end

  test 'should not destroy sectors when destroying organization' do
    @sector = sectors(:one)
    assert_difference('Sector.count', 0) do
      delete organization_url(@organization)
    end

    assert_redirected_to organizations_url
  end

  test 'should not destroy products when destroying organization' do
    @product = products(:one)
    assert_difference('Product.count', 0) do
      delete organization_url(@organization)
    end

    assert_redirected_to organizations_url
  end

  test 'should not destroy contact when destroying organization' do
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

    first_country = countries(:one)
    second_organization = organizations(:two)
    second_organization.countries.push(first_country)
    second_organization.save

    add_parameter = { 'filter_name': 'countries',
                      'filter_value': first_country.id,
                      'filter_label': first_country.name }
    post '/add_filter', params: add_parameter

    # Country filter: should return the above org plus the first org, which has a project assigned to that location
    get organizations_url
    assert_equal(2, assigns(:organizations).count)
    assert_equal(second_organization.name, assigns(:organizations)[1].name)

    # Combination assessment with origins:
    # * should return 0 organizations
    add_parameter = { 'filter_name': 'sectors', 'filter_value': first_sector.id, 'filter_label': first_sector.name }
    post '/add_filter', params: add_parameter

    get organizations_url
    assert_equal(2, assigns(:organizations).count)

    remove_parameter = { filter_array: { '0' => { filter_name: 'sectors' } } }
    post '/remove_filter', params: remove_parameter

    get organizations_url
    assert_equal(2, assigns(:organizations).count)

    remove_parameter = { filter_array: { '0' => { filter_name: 'countries' } } }
    post '/remove_filter', params: remove_parameter

    get organizations_url
    assert_equal(5, assigns(:organizations).count)
  end

  test 'Policy test: should reject edit for organization user' do
    organization = organizations(:four)
    sign_in(
      FactoryBot.create(:user, username: 'user',
                               email: 'user@fourth-organization.com',
                               organization_id: organization.id)
    )

    get organization_url(organization)
    assert_response :success
    assert_equal(0, assigns(:organization).countries.length)

    # Should be able to go to edit page for the organization
    get edit_organization_url(organization)
    assert_response :success

    # Should not be able to go to edit page for other organization.
    get edit_organization_url(organizations(:two))
    assert_response :redirect

    assert_equal(organization.is_endorser, true)

    country = countries(:one)

    patch_params = { organization: {
      is_endorser: false,
      name: 'Some random new name',
      website: 'some-fancy-website.com',
      when_endorsed: '11/16/2018'
    }, selected_countries: {
      "#{country.id}": country.id
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
    assert_equal(1, assigns(:organization).countries.length)

    sign_in(
      FactoryBot.create(:user, username: 'some-admin', email: 'some-admin@digitalimpactalliance.org', roles: [:admin])
    )

    patch(organization_url(organization), params: patch_params)
    get organization_url(organization)

    # Patching should not update is_endorser, name, website and year.
    assert_equal(false, assigns(:organization).is_endorser)
    assert_equal('Some random new name', assigns(:organization).name)
    assert_equal('some-fancy-website.com', assigns(:organization).website)
    assert_equal(2018, assigns(:organization).when_endorsed.year)
  end

  test 'Policy tests: Should only allow get' do
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@digitalimpactalliance.org')

    get organization_url(@organization)
    assert_response :success

    get new_organization_url
    assert_response :redirect

    get edit_organization_url(@organization)
    assert_response :redirect

    patch organization_url(@organization),
          params: { organization: { is_endorser: @organization.is_endorser, name: @organization.name,
                                    slug: @organization.slug, website: @organization.website,
                                    when_endorsed: '11/16/2018' } }
    assert_response :redirect

    delete organization_url(@organization)
    assert_response :redirect
  end

  test 'organization changes should be logged' do
    delete(destroy_user_session_url)
    sign_in FactoryBot.create(:user, username: 'admin', email: 'admin@abba.org', roles: ['admin'])

    uploaded_file = fixture_file_upload('logo.png', 'image/png')

    country = countries(:one)
    product = products(:one)
    sector = sectors(:one)
    project = projects(:one)

    assert_difference('Organization.count') do
      post organizations_url, params: { organization: { name: 'Some Name', slug: 'some_name',
                                                        when_endorsed: '11/16/2018' },
                                        contact: { name: 'Example Contact', email: 'a@a.com' },
                                        selected_countries: { country.id => country.id },
                                        selected_sectors: { sector.id => sector.id },
                                        selected_products: { product.id => product.id },
                                        selected_projects: { project.id => project.id },
                                        duplicate: true, reslug: true, logo: uploaded_file }
    end

    created_organization = Organization.last
    assert_redirected_to organization_url(created_organization)

    assert_equal(created_organization.countries.length, 1)
    assert_equal(created_organization.sectors.length, 1)
    assert_equal(created_organization.products.length, 1)
    assert_equal(created_organization.projects.length, 1)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'CREATED')
    assert_equal(created_audit.username, 'admin@abba.org')

    # Audit will have 3 elements:
    # * Base entity changes.
    # * Mapping changes (optional)
    # * Image changes (optional)
    assert_equal(created_audit.audit_changes.length, 3)

    mapping_changes_audit = created_audit.audit_changes[1]
    assert_equal(mapping_changes_audit.keys.length, 5)
    assert_equal(mapping_changes_audit['countries'].length, 1)
    assert_equal(mapping_changes_audit['sectors'].length, 1)
    assert_equal(mapping_changes_audit['products'].length, 1)
    assert_equal(mapping_changes_audit['projects'].length, 1)
    assert_equal(mapping_changes_audit['contacts'].length, 1)

    other_project = projects(:two)
    patch organization_url(created_organization), params: {
      organization: {
        name: created_organization.name, website: created_organization.website
      },
      selected_projects: {
        project.id => project.id,
        other_project.id => other_project.id
      }
    }

    updated_organization = Organization.find(created_organization.id)
    assert_redirected_to organization_url(updated_organization, locale: 'en')
    assert_equal(updated_organization.projects.length, 2)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'UPDATED')
    assert_equal(created_audit.username, 'admin@abba.org')

    # Audit will have 1 elements:
    # * Mapping changes (optional)
    assert_equal(created_audit.audit_changes.length, 1)

    mapping_changes_audit = created_audit.audit_changes[0]
    assert_equal(mapping_changes_audit['projects'].length, 1)

    other_sector = sectors(:two)
    patch organization_url(updated_organization), params: {
      organization: {
        name: updated_organization.name, website: updated_organization.website
      },
      selected_sectors: {
        other_sector.id => other_sector.id
      }
    }

    updated_organization = Organization.find(updated_organization.id)
    assert_redirected_to organization_url(updated_organization, locale: 'en')
    # Content editor users are allowed to remove and add mapping.
    assert_equal(updated_organization.sectors.length, 1)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'UPDATED')
    assert_equal(created_audit.username, 'admin@abba.org')

    # Audit will have 1 elements:
    # * Mapping changes (optional)
    assert_equal(created_audit.audit_changes.length, 1)

    mapping_changes_audit = created_audit.audit_changes[0]
    # One for removing original sector and one for adding new sector.
    assert_equal(mapping_changes_audit['sectors'].length, 2)

    patch organization_url(updated_organization), params: {
      organization: {
        name: updated_organization.name, website: updated_organization.website
      },
      selected_sectors: {}
    }

    updated_organization = Organization.find(updated_organization.id)
    assert_redirected_to organization_url(updated_organization, locale: 'en')
    # Content editor users are allowed to remove mapping
    assert_equal(updated_organization.sectors.length, 1)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'UPDATED')
    assert_equal(created_audit.username, 'admin@abba.org')

    # Audit will have 1 elements:
    # * Mapping changes (optional)
    assert_equal(created_audit.audit_changes.length, 1)
  end

  test 'mni user allowed to edit mni organizations' do
    patch organization_url(@organization), params: { organization: { name: 'Some Name', is_mni: true } }

    delete(destroy_user_session_url)
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@abba.org', roles: ['mni'])

    get edit_organization_url(@organization)
    assert_response :success

    patch organization_url(@organization), params: { organization: { name: 'Another Name' } }

    updated_organization = Organization.find(@organization.id)
    assert_redirected_to organization_url(updated_organization, locale: 'en')
    assert_equal updated_organization.name, 'Another Name'

    get edit_organization_url(organizations(:two))
    assert_response :redirect

    patch organization_url(organizations(:two)), params: { organization: { name: 'Different Name' } }
    assert_response :redirect

    updated_organization = Organization.find(organizations(:two).id)
    assert_equal updated_organization.name, 'Organization Again'
  end

  test 'principle user allowed to edit principle organizations' do
    patch organization_url(@organization), params: { organization: { name: 'Some Name', is_endorser: true } }

    delete(destroy_user_session_url)
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@abba.org', roles: ['principle'])

    get edit_organization_url(@organization)
    assert_response :success

    patch organization_url(@organization), params: { organization: { name: 'Another Name' } }

    updated_organization = Organization.find(@organization.id)
    assert_redirected_to organization_url(updated_organization, locale: 'en')
    assert_equal updated_organization.name, 'Another Name'

    get edit_organization_url(organizations(:two))
    assert_response :redirect

    patch organization_url(organizations(:two)), params: { organization: { name: 'Different Name' } }
    assert_response :redirect

    updated_organization = Organization.find(organizations(:two).id)
    assert_equal updated_organization.name, 'Organization Again'
  end
end
