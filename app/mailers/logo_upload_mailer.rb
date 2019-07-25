class LogoUploadMailer < ApplicationMailer
  def notify_upload
    @user = params[:user]
    @filename =  params[:filename]
    
    @name = params[:name]
    @type = params[:type]
    mail(from:"notifier@registry.dial.community", to: ["nribeka@digitalimpactalliance.org", "sconrad@digitalimpactalliance.org"], subject: 'New Logo Received!')
  end
end
