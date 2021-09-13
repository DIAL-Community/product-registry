# frozen_string_literal: true

class EntityUploader < CarrierWave::Uploader::Base
  after :store, :send_notification
  storage :file

  def initialize(file_name, current_user)
    super()
    @file_name = file_name
    @current_user = current_user
  end

  def current_filename
    @filename
  end

  def filename
    @filename = "#{@current_user.username}-#{SecureRandom.uuid}-#{@file_name}"
    @filename
  end

  def store_dir
    Rails.root.join('public', 'assets', 'entities')
  end

  def extension_whitelist
    %w(json csv txt)
  end

  def content_type_whitelist
    %w(text/plain text/csv application/json)
  end

  def send_notification(file)
    EntityUploadMailer
      .with(user: @current_user,
            filename: file.original_filename)
      .notify_upload
      .deliver_later
  end
end
