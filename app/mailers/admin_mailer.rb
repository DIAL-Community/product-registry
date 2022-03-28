# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def send_mail_from_client(mailFrom, mailTo, emailSubject, emailBody)
    # issues@solutions.dial.community

    mail(from: mailFrom,
         to: mailTo,
         subject: emailSubject,
         body: emailBody)
  end

  def notify_product_owner_request
    admin_users = User.where(receive_admin_emails: true)
    user_hash = params[:user]

    email_subject = 'User Sign Up Request'
    email_body = "New user '#{user_hash[:email]}' has requested access to the registry. "\
                 'Approval from an admin user is required.'
    if user_hash[:product_id].present?
      products = Product.where(id: user_hash[:product_id])
      email_subject = 'Product Owner Request'
      email_body = "New user '#{user_hash[:email]}' has requested product(s) ownership of: "\
                   "[#{products.collect(&:name).join(', ')}]. "\
                   'Approval from an admin user is required.'
    elsif user_hash[:organization_id].present?
      organization = Organization.find(user_hash[:organization_id])
      email_subject = 'Organization Owner Request'
      email_body = "New user '#{user_hash[:email]}' has requested organization ownership of: [#{organization.name}]. "\
                   'Approval from an admin user is *NOT* required.'
    end
    mailTo = ''
    admin_users.each do |admin|
      mailTo += "#{admin.email}; "
    end
    mail(from: 'notifier@solutions.dial.community',
         to: mailTo,
         subject: email_subject,
         body: email_body)
  end

  def notify_product_owner_approval
    mail(from: 'notifier@solutions.dial.community',
         to: [params[:user_email]],
         subject: 'Product Owner Approval',
         body: 'Your account have been approved in the DIAL Catalog (https://solutions.dial.community).'\
               'You may now log in to the system.')
  end

  def notify_ux_ownership_request
    admin_users = User.where(receive_admin_emails: true)
    user_hash = params[:user]
    if user_hash[:product_id].present?
      product = Product.where(id: user_hash[:product_id])
      email_subject = 'Product Owner Request'
      email_body = "User '#{user_hash[:email]}' has requested product ownership of: #{product.name}. "\
                   'Approval from an admin user is required.'
    elsif user_hash[:organization_id].present?
      organization = Organization.find(user_hash[:organization_id])
      email_subject = 'Organization Owner Request'
      email_body = "User '#{user_hash[:email]}' has requested organization ownership of: [#{organization.name}]. "\
                   'Approval from an admin user is required.'
    end
    mailTo = ''
    admin_users.each do |admin|
      mailTo += "#{admin.email}; "
    end
    mail(from: 'notifier@solutions.dial.community',
         to: mailTo,
         subject: email_subject,
         body: email_body)
  end
end
