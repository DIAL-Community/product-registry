module Auditable
  extend ActiveSupport::Concern

  included do
    after_save { create_audit("UPDATED") }
    before_destroy { create_audit("DELETED") }
  end

  def create_audit(action)
    audit_log = Audit.new
    audit_log.associated_type = self.class.name
    audit_log.associated_id = self.slug
    audit_log.action = action
    if action == "UPDATED" && self.saved_change_to_id?
      audit_log.action = "CREATED"
    end
    current_user = get_current_user
    if (current_user)
      audit_log.user_id = current_user.id
      audit_log.user_role = current_user.role
      audit_log.username = current_user.email
    end
    audit_changes = []
    if !self.saved_changes.empty?
      audit_changes.push(self.saved_changes)
    end
    if !association_changes.nil?
      audit_changes.push(self.association_changes)
    end
    if (!get_image_changed.nil?)
      audit_changes.push({"image":get_image_changed.to_s})
    end
    if !audit_changes.empty? || audit_log.action == "DELETED"
      audit_log.audit_changes = audit_changes
      audit_log.save
    end
  end

  def set_current_user(user)
    @current_user = user
  end

  def get_current_user
    @current_user
  end

  def set_image_changed(filename)
    @image_changed = filename
  end

  def get_image_changed
    @image_changed
  end
end