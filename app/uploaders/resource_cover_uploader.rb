# encoding: utf-8

class ResourceCoverUploader < CarrierWave::Uploader::Base
  # include CarrierWave Backgrounder
  include ::CarrierWave::Backgrounder::Delay

  # include CarrierWave MiniMagick
  include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "resource/cover/#{model.id}"
  end

  def filename
    "original.#{model.cover.file.extension}" if original_filename
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [309, 206]
    process :convert => 'jpg'
    def full_filename (for_file = model.image.file)
      "thumb.jpg"
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def size_range
    1..5.megabytes
  end
end
