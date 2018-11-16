# resource item children
class ResourceContent < ActiveRecord::Base
  include Nameable

  belongs_to :resource_item

  # globalize
  mount_uploader :visual_en, ResourceContentUploader
  mount_uploader :visual_ka, ResourceContentUploader

    translates :content
    globalize_accessors :locales => [:en, :ka], :attributes => [:content]#, :content]

  # scopes
    default_scope { order(:order) }

  # validators

  # getters
    def has_content?
      return content_en.present? || content_ka.present?
    end

    def has_visual?
      return visual_en.present? || visual_ka.present?
    end

    # def self.by_name(name)
    #   find_by(name: name)
    # end

    def visual()
      self.send('visual_' + I18n.locale.to_s)
    end
end
