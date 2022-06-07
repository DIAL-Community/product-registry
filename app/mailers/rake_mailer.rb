# frozen_string_literal: true
class RakeMailer < ActionMailer::Base
  def sync_product_added(user_email, email_body)
    mail(from: 'notifier@solutions.dial.community',
        to: [user_email],
        subject: 'Nightly sync - products added',
        body: email_body)
  end

  def sync_product_removed(user_email, email_body)
    mail(from: 'notifier@solutions.dial.community',
        to: [user_email],
        subject: 'Nightly sync - products deleted',
        body: email_body)
  end

  def database_backup(user_email, email_body)
    attachments['registry.dump'] = File.read('/t4d/db/backups/registry.dump')
    mail(from: 'notifier@solutions.dial.community',
        to: [user_email],
        subject: 'Nightly sync - products added',
        body: email_body)
  end
end
