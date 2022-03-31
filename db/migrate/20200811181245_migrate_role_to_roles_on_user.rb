# frozen_string_literal: true

class MigrateRoleToRolesOnUser < ActiveRecord::Migration[5.2]
  def up
    User.where.not(role: nil).each do |unmigrated_user|
      if unmigrated_user.role != User.user_roles[:org_product_user]
        unmigrated_user.roles << unmigrated_user.role
      else
        unmigrated_user.roles << User.user_roles[:org_user]
        unmigrated_user.roles << User.user_roles[:product_user]
      end

      unmigrated_user.role = nil

      puts "Migrated user role information for: #{unmigrated_user.email}." if unmigrated_user.save!
    end
  end

  def down
    User.where.not("roles = '{}'").each do |unmigrated_user|
      if unmigrated_user.roles.include?(User.user_roles[:product_user]) &&
         unmigrated_user.roles.include?(User.user_roles[:org_user]) &&
         unmigrated_user.roles.size == 2
        unmigrated_user.role = User.user_roles[:org_product_user]
      elsif unmigrated_user.roles.size == 1
        unmigrated_user.role = unmigrated_user.roles.first
      else
        puts "Unable to migrate role information for #{unmigrated_user.email}."
      end

      unmigrated_user.roles = []

      puts "Migrated user role information for: #{unmigrated_user.email}." if unmigrated_user.save!
    end
  end
end
