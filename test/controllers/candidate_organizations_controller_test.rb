require 'test_helper'

class CandidateOrganizationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, role: :admin)
    @candidate_organization = candidate_organizations(:one)
  end

  test "should get index" do
    get candidate_organizations_url
    assert_response :success
  end

  test "should get new" do
    get new_candidate_organization_url
    assert_response :success
  end

  test "should create candidate_organization" do
    assert_difference('CandidateOrganization.count') do
      post candidate_organizations_url, params: { candidate_organization: { name: @candidate_organization.name, slug: @candidate_organization.slug, website: @candidate_organization.website } }
    end

    assert_redirected_to candidate_organization_url(CandidateOrganization.last)
  end

  test "should show candidate_organization" do
    get candidate_organization_url(@candidate_organization)
    assert_response :success
  end

  test "should get edit" do
    get edit_candidate_organization_url(@candidate_organization)
    assert_response :success
  end

  test "should update candidate_organization" do
    patch candidate_organization_url(@candidate_organization), params: { candidate_organization: { name: @candidate_organization.name, slug: @candidate_organization.slug, website: @candidate_organization.website } }
    assert_redirected_to candidate_organization_url(@candidate_organization)
  end

  test "should destroy candidate_organization" do
    assert_difference('CandidateOrganization.count', -1) do
      delete candidate_organization_url(@candidate_organization)
    end

    assert_redirected_to candidate_organizations_url
  end
end
