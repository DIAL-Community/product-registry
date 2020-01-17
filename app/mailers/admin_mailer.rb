class AdminMailer < ApplicationMailer
  def notify_product_owner_request
    admin_users = User.where(role: 'admin')
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
    admin_users.each do |admin|
      mail(from: 'notifier@registry.dial.community',
           to: [admin.email],
           subject: email_subject,
           body: email_body)
    end
  end

  def notify_product_owner_approval
    mail(from: 'notifier@registry.dial.community',
         to: [params[:user_email]],
         subject: 'Product Owner Approval',
         body: 'Your account have been approved in the DIAL product registry (https://registry.dial.community).'\
               'You may now log in to the system.')
  end
end
