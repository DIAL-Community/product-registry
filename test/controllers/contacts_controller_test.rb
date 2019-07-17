require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, role: :admin)
    @contact = contacts(:one)
  end

  test "should get index" do
    get contacts_url
    assert_response :success
  end

  test "search test" do
    get contacts_url(:search=>"Contact1")
    assert_equal(1, assigns(:contacts).count)

    get contacts_url(:search=>"InvalidContact")
    assert_equal(0, assigns(:contacts).count)
  end

  test "should get new" do
    get new_contact_url
    assert_response :success
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      post contacts_url, params: { contact: { name: @contact.name, slug: 'testslug', email: @contact.email, title: @contact.title } }
    end

    assert_redirected_to contact_url(Contact.last)
  end

  test "should show contact" do
    get contact_url(@contact)
    assert_response :success
  end

  test "should get edit" do
    get edit_contact_url(@contact)
    assert_response :success
  end

  test "should update contact" do
    patch contact_url(@contact), params: { contact: { email: @contact.email, name: @contact.name, slug: @contact.slug, title: @contact.title } }
    assert_redirected_to contact_url(@contact)
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete contact_url(@contact)
    end

    assert_redirected_to contacts_url
  end

  test "Policy tests: should reject new, edit, update, delete actions for regular user. Should allow get" do
    sign_in FactoryBot.create(:user, email: 'nonadmin@digitalimpactalliance.org')

    get contact_url(@contact)
    assert_response :success
    
    get new_contact_url
    assert_response :redirect

    get edit_contact_url(@contact)
    assert_response :redirect    

    patch contact_url(@contact), params: { contact: { email: @contact.email, name: @contact.name, slug: @contact.slug, title: @contact.title } }
    assert_response :redirect  

    delete contact_url(@contact)
    assert_response :redirect
  end
end
