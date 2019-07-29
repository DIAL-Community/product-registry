class LogoUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  after :store, :send_notification

  def initialize(model, file_name, current_user)
    super(model, nil)
    @file_name = file_name
    @current_user = current_user
  end

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    Rails.root.join('app','assets','images', "#{model.class.to_s.underscore}s")
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  process resize_image: 640
  def resize_image(size)
    manipulate! do |image|                 
      if image[:width] < image[:height]
        if image[:height] > size
          image.resize("x#{size}>")
        elsif image[:height] < size
          image.resize("x#{size}<")
        end
      else
        if image[:width] > size
          image.resize("#{size}>")
        elsif image[:width] < size
          image.resize("#{size}<")
        end
      end
      image.format('png')
      image
    end
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  # process resize_to_fit: [640, 640]

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg png)
  end

  def content_type_whitelist
    [/image\//]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{model.slug}.png"
  end

  def send_notification(file)
    LogoUploadMailer
      .with(user: @current_user,
            filename: file.original_filename,
            name: model.name,
            type: model.class.to_s.downcase)
      .notify_upload
      .deliver_later
  end
end
