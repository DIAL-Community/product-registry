# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  after_action :record_failed_auth, only: :new

  def create
    super
    record_auth_event(UserEvent.event_types[:login_success])
  end

  private

  def record_failed_auth
    record_auth_event(UserEvent.event_types[:login_failed]) if failed_login?
  end

  def failed_login?
    (options = request.env['warden.options']) && options[:action] == 'unauthenticated'
  end

  def record_auth_event(event_type)
    user_event = UserEvent.new
    user_event.identifier = session[:default_identifier]
    user_event.event_type = event_type
    user_event.event_datetime = Time.now

    user_event.email = current_user.email unless current_user.nil?

    logger.info("User event '#{event_type}' for #{user_event.identifier} saved.") if user_event.save!
  end
end
