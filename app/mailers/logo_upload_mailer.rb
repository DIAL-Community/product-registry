class LogoUploadMailer < ApplicationMailer
  def notify_upload
    @user = params[:user]
    @filename = params[:filename]
    @name = params[:name]
    @type = params[:type]

    admin_users = User.where(receive_admin_emails: true)
    admin_users.each do |admin|
      mail(from: 'notifier@solutions.dial.community',
           to: [admin.email],
           subject: 'New Logo Received.')
    end
  end
end
