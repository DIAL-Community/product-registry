# frozen_string_literal: true

require 'modules/notifier'

include Modules::Notifier

namespace :notifier do
  desc 'Notify admins of new comments.'
  task :daily_comment_digest, [:path] => :environment do |_, _|
    admin_users = User.where(receive_admin_emails: true)

    email_subject = 'Recent comments made in the Catalog'

    recent_comments = Comment.where('created_at >= ?', 1.day.ago)
    return if recent_comments.nil?

    email_body = "Comments posted in the past day: <br /><br />"
    recent_comments.each do |comment|
      email_body +=  "From: #{comment.author['username']}: #{comment.text} <br />" \
        "Click on <a href='#{get_comment_link(comment)}'>this link</a> to view this comment <br /><br />"
    end

    admin_users.each do |admin|
      AdminMailer.send_mail_from_client('notifier@solutions.dial.community',
         admin.email, email_subject, email_body, "text/html").deliver_now
    end
  end
end
