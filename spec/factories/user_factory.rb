# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :user do
    email { 'usertest@digitalimpactalliance.org' }
    username { 'some-default-username' }
    password { 'password' }
    password_confirmation { 'password' }
    confirmed_at { Date.today }
    roles { [:user] }
  end
end
