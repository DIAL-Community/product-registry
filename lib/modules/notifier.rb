# frozen_string_literal: true
include Rails.application.routes.url_helpers

module Modules
  module Notifier
    def notify_commenter(comment)
      parent_comment = Comment.find_by(comment_id: comment.parent_comment_id)
      return if parent_comment.nil?

      # Get the parent commenter's email address
      originator = User.find(parent_comment.author["id"])

      email_body = "#{comment.author['username']} Replied: \n\n" \
                 "#{comment.text} \n\n" \
                 "Click on <a href='#{get_comment_link(comment)}'>this link</a> to view comments"

      AdminMailer.send_mail_from_client('notifier@solutions.dial.community', originator.email,
                                "#{comment.author['username']} Responded to your comment", email_body, 'text/html')
                 .deliver_now
    end

    def get_comment_link(comment)
      # 'PRODUCT','OPEN_DATA','PROJECT','USE_CASE','BUILDING_BLOCK','PLAYBOOK','ORGANIZATION'
      link_url = Rails.application.secrets.base_url + '/' unless Rails.application.secrets.base_url.nil?
      link_url = "" if Rails.application.secrets.base_url.nil?
      case comment.comment_object_type
      when 'PRODUCT'
        comment_object = Product.find(comment.comment_object_id)
        link_url += "products/#{comment_object.slug}" unless comment_object.nil?
      when 'OPEN_DATA'
        comment_object = Dataset.find(comment.comment_object_id)
        link_url += "datasets/#{comment_object.slug}" unless comment_object.nil?
      when 'USE_CASE'
        comment_object = UseCase.find(comment.comment_object_id)
        link_url += "use_cases/#{comment_object.slug}" unless comment_object.nil?
      when 'BUILDING_BLOCK'
        comment_object = BuildingBlock.find(comment.comment_object_id)
        link_url += "building_blocks/#{comment_object.slug}" unless comment_object.nil?
      when 'PLAYBOOK'
        comment_object = Playbook.find(comment.comment_object_id)
        link_url += "playbooks/#{comment_object.slug}" unless comment_object.nil?
      when 'ORGANIZATION'
        comment_object = Organization.find(comment.comment_object_id)
        link_url += "organizations/#{comment_object.slug}" unless comment_object.nil?
      end
      link_url
    end
  end
end
