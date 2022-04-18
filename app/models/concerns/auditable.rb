# frozen_string_literal: true

module Auditable
  extend ActiveSupport::Concern

  included do
    after_save { create_audit('UPDATED') }
    before_destroy { create_audit('DELETED') }
  end

  def create_audit(action)
    audit_log = Audit.new
    audit_log.associated_type = self.class.name
    if has_attribute?(:slug)
      audit_log.associated_id = slug
    else
      audit_log.associated_id = get_parent_slug(self)
    end
    audit_log.action = action
    audit_log.action = 'CREATED' if action == 'UPDATED' && saved_change_to_id?
    current_user = fetch_current_user
    if current_user
      audit_log.user_id = current_user.id
      audit_log.user_role = current_user.roles
      audit_log.username = current_user.email
    end
    audit_changes = []
    audit_changes.push(saved_changes) unless saved_changes.empty?
    audit_changes.push(association_changes) unless association_changes.nil?
    audit_changes.push({ "image": fetch_image_changed.to_s }) unless fetch_image_changed.nil?
    if !audit_changes.empty? || audit_log.action == 'DELETED'
      audit_log.audit_changes = audit_changes
      audit_log.save
    end
  end

  def auditable_current_user(user)
    @current_user = user
  end

  def fetch_current_user
    @current_user
  end

  def auditable_image_changed(filename)
    @image_changed = filename
  end

  def fetch_image_changed
    @image_changed
  end

  def get_parent_slug(child_object)
    if child_object.instance_of?(UseCaseDescription)
      UseCase.find(child_object.use_case_id).slug
    elsif child_object.instance_of?(BuildingBlockDescription)
      BuildingBlock.find(child_object.building_block_id).slug
    elsif child_object.instance_of?(WorkflowDescription)
      Workflow.find(child_object.workflow_id).slug
    elsif child_object.instance_of?(ProductDescription)
      Product.find(child_object.product_id).slug
    else
      'None'
    end
  end

  def association_add(new_obj)
    initialize_association_changes
    if new_obj.instance_of?(SdgTarget)
      curr_change = { id: new_obj.name, action: 'ADD' }
    elsif new_obj.auditable_association_object
      curr_change = { id: new_obj.audit_id_value, action: 'ADD' }
    else
      curr_change = { id: new_obj.slug, action: 'ADD' }
    end
    log_association(curr_change, new_obj)
  end

  def association_remove(old_obj)
    initialize_association_changes
    if old_obj.instance_of?(SdgTarget)
      curr_change = { id: old_obj.name, action: 'REMOVE' }
    elsif old_obj.auditable_association_object
      curr_change = { id: old_obj.audit_id_value, action: 'REMOVE' }
    else
      curr_change = { id: old_obj.slug, action: 'REMOVE' }
    end
    log_association(curr_change, old_obj)
  end

  def log_association(curr_change, object)
    return if curr_change[:id].nil?

    field_name = object.class.name.pluralize.downcase
    field_name = object.audit_field_name.downcase if object.auditable_association_object
    (@association_changes[field_name] ||= []) << curr_change
    @association_changes[field_name].uniq!
  end

  def initialize_association_changes
    @association_changes = {} if @association_changes.nil?
  end

  def association_changes
    @association_changes
  end
end
