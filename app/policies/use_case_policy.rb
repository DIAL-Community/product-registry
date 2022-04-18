# frozen_string_literal: true

class UseCasePolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    super(user, record)
  end

  def create_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:ict4sdg]) ||
      user.roles.include?(User.user_roles[:content_editor]) ||
      user.roles.include?(User.user_roles[:content_writer])
  end

  def mod_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:ict4sdg]) ||
      user.roles.include?(User.user_roles[:content_editor]) ||
      user.roles.include?(User.user_roles[:content_writer])
  end

  def delete_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:ict4sdg])
  end

  def view_allowed?
    true
  end

  def beta_only?
    return true if user.nil?

    !user.roles.include?(User.user_roles[:content_editor]) &&
      !user.roles.include?(User.user_roles[:admin]) &&
      !user.roles.include?(User.user_roles[:ict4sdg])
  end
end
