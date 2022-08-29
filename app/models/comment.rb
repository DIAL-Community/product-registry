# frozen_string_literal: true

class Comment < ApplicationRecord
  def replies
    Comment.where(parent_comment_id: comment_id)
  end

  def com_id
    comment_id
  end

  def user_id
    author['id'].to_s
  end

  def full_name
    author['username']
  end

  def avatar_url
    "https://ui-avatars.com/api/name=" + author['username'] + "&background=random"
  end
end
