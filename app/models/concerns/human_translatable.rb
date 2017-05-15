module HumanTranslatable
  extend ActiveSupport::Concern

  included do
    def self.human_attribute_name(attribute, options = {})

      options   = { count: 1 }.merge!(options)
      parts     = attribute.to_s.split(".")
      attribute = parts.pop
      locale = nil

      disassembled_attribute = attribute.to_s.scan(/(.*)_(#{I18n.available_locales.join('|')})$/)
      if disassembled_attribute.present?
        attribute = disassembled_attribute[0][0]
        locale = disassembled_attribute[0][1]
      end

      namespace = parts.join("/") unless parts.empty?
      attributes_scope = "#{i18n_scope}.attributes"

      if namespace
        defaults = lookup_ancestors.map do |klass|
          :"#{attributes_scope}.#{klass.model_name.i18n_key}/#{namespace}.#{attribute}"
        end
        defaults << :"#{attributes_scope}.#{namespace}.#{attribute}"
      else
        defaults = lookup_ancestors.map do |klass|
          :"#{attributes_scope}.#{klass.model_name.i18n_key}.#{attribute}"
        end
      end

      defaults << :"attributes.#{attribute}"
      defaults << options.delete(:default) if options[:default]
      defaults << attribute.humanize
       # Rails.logger.debug("--------------------------------------------#{defaults.inspect}")

      options[:default] = defaults

       # Rails.logger.debug("--------------------------------------------#{defaults.shift}#{options}")
      globalize_string = locale.present? ? (" (%s)" % [I18n.t("app.languages.#{locale}")]) : nil

      "#{I18n.translate(defaults.shift, options)}#{globalize_string}"



      #  Rails.logger.debug("---------------------------------------human-----#{attr}")
      # if self.globalize_attribute_names.include?(attr)
      #


      #   attr_path = disassembled[0].index('.').present? ? disassembled[0] : "#{self.name.underscore.downcase}.#{disassembled[0]}"
      #  Rails.logger.debug("--------------------------------------------#{[I18n.t("#{i18n_scope}.attributes.#{attr_path}"), I18n.t("app.languages.#{disassembled[1]}")]}")
      #   "%s (%s)" % [I18n.t("#{i18n_scope}.attributes.#{attr_path}"), ]
      # else
      #   super
      # end
    end
  end
end



def human_attribute_name(attribute, options = {})

end
