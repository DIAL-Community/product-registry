class AdminMailer < ApplicationMailer
  def notify_product_owner_request
    adminUsers = User.where(role: 'admin')
    userhash = params[:user]
    product = Product.where(id: userhash[:product_id].first).first
    
    adminUsers.each do |admin|
      mail(from:"notifier@registry.dial.community", to: [admin.email], subject: 'Product Owner Request', body: "New user " + userhash[:email] + " has requested product ownership of " + product.name )
    end
  end

  def notify_product_owner_approval
    
    mail(from:"notifier@registry.dial.community", to: [params[:user_email]], subject: 'Product Owner Approval', body: "You have been approved as a product owner in the DIAL producgt registry (https://registry.dial.community). You may now log in - you have edit permissions for your product." )
  end
end
