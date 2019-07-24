class LogoUploadMailer < ApplicationMailer
  def notify_upload
    @url =  params[:url]
    @user = params[:user]
    mail(from:"notifier@registry.dial.community", to: "nribeka@digitalimpactalliance.org", subject: 'New Logo Received!')
  end
end
