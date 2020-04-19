class DisableSessionLogger < ::Logger
  def info(message, *args, &block)
    super unless message.include? 'UPDATE "sessions" SET "data"'
  end
end

# TODO: Disable this to show the sessions db operation.
# We will not see this in production because production have the db logging disabled.
ActiveRecord::Base.logger = ActiveSupport::TaggedLogging.new(DisableSessionLogger.new(STDOUT)) unless Rails.env.test?
