# frozen_string_literal: true

require 'modules/slugger'
include(Modules::Slugger)

module Modules
  # Task tracker utility functions.
  module Track
    def track_task(task_name, message)
      task_slug = slug_em(task_name)
      task_tracker = TaskTracker.find_by(slug: task_slug)
      if task_tracker.nil?
        task_tracker = TaskTracker.new
        task_tracker.name = task_name
        task_tracker.slug = task_slug
      end

      task_tracker.message = message
      task_tracker.last_run = Time.now
      puts "Task: '#{task_name}' recorded with message: '#{message}'." if task_tracker.save!
    end

    def start_tracking_task(task_name)
      track_task(task_name, 'Starting up task ...')
    end

    def end_tracking_task(task_name)
      track_task(task_name, 'Task completed.')
    end

    def exception_tracking_task(task_name, message)
      track_task(task_name, message)
    end
  end
end
