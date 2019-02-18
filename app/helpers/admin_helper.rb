module AdminHelper

  # Capitalized item name, with nil check
  def capitalized_name(name)
    result = ''
    if name
      result = name.slice(0,1).capitalize + name.slice(1..-1)
    end
    return result
  end

  def user_profile_pages
    [:'manage-profile', :'favorite-places', :'rated-places', :'uploaded-photos']
  end

  def provider_profile_pages
    [:'manage-providers', :'manage-places', :'moderate-photos']
  end

  def label_format(label, options)
     Rails.logger.debug("--------------------------------------------#{label} #{options}")
    lb = label
    if options.present?
      if options.key?(:required) && options[:required]
        if lb.last == ':'
          lb.gsub!(':','*:')
        else
          lb.concat('*')
        end
      end
    end
    return lb
  end

  def boolean_format(flag)
    if flag == true
      return "<div class='boolean-flag boolean-flag-true'>#{t('app.common._yes')}</div>".html_safe
    else
      return "<div class='boolean-flag boolean-flag-false'>#{t('app.common._no')}</div>".html_safe
    end
  end
end
