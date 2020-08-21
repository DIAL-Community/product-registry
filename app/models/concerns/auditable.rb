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

  def association_add(new_obj)
    initialize_association_changes
    if new_obj.class.name == ProductSector.name
      curr_change = { id: new_obj.sector.slug, action: "ADD" }
    elsif new_obj.class.name == ProductBuildingBlock.name
      curr_change = { id: new_obj.building_block.slug, action: "ADD" }
    elsif new_obj.class.name == ProductSustainableDevelopmentGoal.name
      curr_change = { id: new_obj.sustainable_development_goal.slug, action: "ADD" }
    else
      curr_change = { id: new_obj.slug, action: "ADD" }
    end
    log_association(curr_change, new_obj.class.name)
  end

  def association_remove(old_obj)
    initialize_association_changes
    if old_obj.class.name == ProductSector.name
      curr_change = { id: old_obj.sector.slug, action: "REMOVE" }
    elsif old_obj.class.name == ProductBuildingBlock.name
      curr_change = { id: old_obj.building_block.slug, action: "REMOVE" }
    elsif old_obj.class.name == ProductSustainableDevelopmentGoal.name
      curr_change = { id: old_obj.sustainable_development_goal.slug, action: "REMOVE" }
    else
      curr_change = { id: old_obj.slug, action: "REMOVE" }
    end
    log_association(curr_change, old_obj.class.name)
  end

  def log_association(curr_change, obj_name)
    case obj_name
    when "Organization"
      (@association_changes[:organizations] ||= []) << curr_change
    when "Sector"
      (@association_changes[:sectors] ||= []) << curr_change
    when "ProductSector"
      (@association_changes[:sectors] ||= []) << curr_change
    when "Product"
      (@association_changes[:products] ||= []) << curr_change
    when "SustainableDevelopmentGoal"
      (@association_changes[:sdgs] ||= []) << curr_change
    when "ProductSustainableDevelopmentGoal"
      (@association_changes[:sdgs] ||= []) << curr_change
    when "BuildingBlock"
      (@association_changes[:building_blocks] ||= []) << curr_change
    when "ProductBuildingBlock"
      (@association_changes[:building_blocks] ||= []) << curr_change
    when "Origin"
      (@association_changes[:origins] ||= []) << curr_change
    when "Location"
      (@association_changes[:locations] ||= []) << curr_change
    when "Contact"
      (@association_changes[:contacts] ||= []) << curr_change
    when "Project"
      (@association_changes[:projects] ||= []) << curr_change
    when "ProductProductRelationship"
      (@association_changes[:products] ||= []) << curr_change
    end
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
