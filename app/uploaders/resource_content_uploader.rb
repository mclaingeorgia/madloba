# encoding: utf-8

class ResourceContentUploader < CarrierWave::Uploader::Base
  # include CarrierWave Backgrounder
  include ::CarrierWave::Backgrounder::Delay

  # include CarrierWave MiniMagick
  include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "resource/content/#{mounted_as[-2,2]}/#{model.id}"
  end

  def filename
    "original.#{model.send(mounted_as).file.extension}" if original_filename
  end

  # Create different versions of your uploaded files:
  version :thumb, if: :is_image? do
    process :resize_to_fit => [309, 206]
    process :convert => 'jpg'
    def full_filename (for_file = model.image.file)
      "thumb.jpg"
    end
  end
  version :preview, if: :is_image? do
    process :resize_to_limit => [900, 100000]
    process :convert => 'jpg'
    def full_filename (for_file = model.image.file)
      "preview.jpg"
    end
  end

  def is_image? file
    file.extension != 'pdf'
  end

  def image?
    return model.send(mounted_as).file.extension != 'pdf'
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png pdf)
  end

  def size_range
    1..5.megabytes
  end
end
