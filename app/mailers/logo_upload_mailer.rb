# frozen_string_literal: true

class LogoUploadMailer < ApplicationMailer
  def notify_upload
    @user = params[:user]
    @filename = params[:filename]
    @name = params[:name]
    @type = params[:type]

    admin_users = User.where(receive_admin_emails: true)
    mailTo = ''
    admin_users.each do |admin|
      mailTo += "#{admin.email}; "
    end
    mail(from: 'notifier@solutions.dial.community',
         to: mailTo,
         subject: 'New Logo Received.')
  end
end
