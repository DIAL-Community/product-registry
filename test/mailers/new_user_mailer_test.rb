require 'test_helper'
require 'active_support/test_case'

class NewUserMailerTest < ActionMailer::TestCase
  VALID_AUTHENTICATION_TOKEN = 'AbCdEfGhIjKlMnOpQrSt'.freeze

  include Devise::Test::IntegrationHelpers

  setup do
    ActionMailer::Base.deliveries = []
    Devise.mailer = 'Devise::Mailer'
    Devise.mailer_sender = 'test@example.com'
  end

  teardown do
    Devise.mailer = 'Devise::Mailer'
    Devise.mailer_sender = 'please-change-me@config-initializers-devise.com'
  end

  def mail
    sign_in FactoryBot.create(:user, roles: [:admin])
    @mail ||= begin
      @user = User.create!({
        'email': 'mailuser1@digitalimpactalliance.org',
        'password': '12345678',
        'password_confirmation': '12345678'
      })
      ActionMailer::Base.deliveries.first
    end
  end

  test 'email sent after creating the user' do
    assert_not_nil mail
  end

  test 'should not allow non DIAL email with invalid organization.' do
    sign_in FactoryBot.create(:user, roles: [:admin])
    @user = User.new({
      'email': 'user1@example.org',
      'password': '12345678',
      'password_confirmation': '12345678',
      'organization_id': organizations(:one).id
    })
    assert_equal(@user.valid?, false)
  end

  test 'should allow non DIAL email with valid organization.' do
    sign_in FactoryBot.create(:user, roles: [:admin])
    @user = User.new({
      'email': 'mailuser@fourth-organization.com',
      'password': '12345678',
      'password_confirmation': '12345678',
      'organization_id': organizations(:four).id
    })
    assert_equal(@user.valid?, true)
  end
end
