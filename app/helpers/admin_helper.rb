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
end
