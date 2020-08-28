module Auditable
  extend ActiveSupport::Concern

  included do
    after_save { create_audit("UPDATED") }
    before_destroy { create_audit("DELETED") }
  end

  def create_audit(action)
    audit_log = Audit.new
    audit_log.associated_type = self.class.name
    if self.has_attribute?(:slug)
      audit_log.associated_id = self.slug
    else 
      audit_log.associated_id = get_parent_slug(self)
    end
    audit_log.action = action
    if action == "UPDATED" && self.saved_change_to_id?
      audit_log.action = "CREATED"
    end
    current_user = get_current_user
    if (current_user)
      audit_log.user_id = current_user.id
      audit_log.user_role = current_user.roles
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
      audit_changes.push({ "image": get_image_changed.to_s })
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

  def get_parent_slug(child_object)
    if child_object.class.name == UseCaseDescription.name
      return UseCase.find(child_object.use_case_id).slug
    elsif child_object.class.name == BuildingBlockDescription.name
      return BuildingBlock.find(child_object.building_block_id).slug
    elsif child_object.class.name == WorkflowDescription.name
      return Workflow.find(child_object.workflow_id).slug
    elsif child_object.class.name == ProductDescription.name
      return Product.find(child_object.product_id).slug
    else
      return "None"
    end
  end

  def association_add(new_obj)
    initialize_association_changes
    if new_obj.class.name == SdgTarget.name
      curr_change = { id: new_obj.name, action: "ADD" }
    elsif new_obj.auditable_association_object
      curr_change = { id: new_obj.audit_id_value, action: "ADD" }
    else
      curr_change = { id: new_obj.slug, action: "ADD" }
    end
    log_association(curr_change, new_obj)
  end

  def association_remove(old_obj)
    initialize_association_changes
    if old_obj.class.name == SdgTarget.name
      curr_change = { id: old_obj.name, action: "REMOVE" }
    elsif old_obj.auditable_association_object
      curr_change = { id: old_obj.audit_id_value, action: "REMOVE" }
    else
      curr_change = { id: old_obj.slug, action: "REMOVE" }
    end
    log_association(curr_change, old_obj)
  end

  def log_association(curr_change, object)
    return if curr_change[:id].nil?

    field_name = object.class.name.pluralize.downcase
    if object.auditable_association_object
      field_name = object.audit_field_name.downcase
    end
    (@association_changes[field_name] ||= []) << curr_change
    @association_changes[field_name].uniq!
  end

  def initialize_association_changes
    if @association_changes.nil?
      @association_changes = {}
    end
  end

  def association_changes
    @association_changes
  end
end
