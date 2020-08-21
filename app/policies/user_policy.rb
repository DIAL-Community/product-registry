class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def index?
    @current_user.roles.include?(User.user_roles[:admin])
  end

  def show?
    @current_user.roles.include?(User.user_roles[:admin])
  end

  def edit?
    @current_user.roles.include?(User.user_roles[:admin])
  end

  def update?
    @current_user.roles.include?(User.user_roles[:admin])
  end

  def create?
    @current_user.roles.include?(User.user_roles[:admin])
  end

  def new?
    @current_user.roles.include?(User.user_roles[:admin])
  end

  def destroy?
    @current_user.roles.include?(User.user_roles[:admin])
  end

  def mni?
    @current_user.roles.include?(User.user_roles[:admin]) || @current_user.roles.include?(User.user_roles[:mni])
  end

  def principle?
    @current_user.roles.include?(User.user_roles[:admin]) || @current_user.roles.include?(User.user_roles[:principle])
  end

  def ict4sdg?
    @current_user.roles.include?(User.user_roles[:admin]) || @current_user.roles.include?(User.user_roles[:ict4sdg])
  end
end
