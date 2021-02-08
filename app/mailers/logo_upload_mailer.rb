class LogoUploadMailer < ApplicationMailer
  def notify_upload
    @user = params[:user]
    @filename =  params[:filename]
    
    @name = params[:name]
    @type = params[:type]
    mail(from:"notifier@solutions.dial.community", to: ["nribeka@digitalimpactalliance.org"], subject: 'New Logo Received!')
  end
end
