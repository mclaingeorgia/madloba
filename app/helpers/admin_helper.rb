module AdminHelper

  # Capitalized item name, with nil check
  def capitalized_name(name)
    result = ''
    if name
      result = name.slice(0,1).capitalize + name.slice(1..-1)
    end
    return result
  end

  def render_form_field(type, form, field_name, translate_path, options=nil, container_options={})
    render partial: "shared/form_inputs/#{type}", locals: { form: form, field: field_name, translate_path: "#{translate_path}#{field_name}", options: options, container_options: container_options }
  end
  def render_form_actions
    render partial: "shared/form_actions"
  end
  def create_field_input(form, field_name, field_data, translate_path)
      Rails.logger.debug("--------------------------------------------#{field_name} #{field_data}")
    type = 'text_field'
    if field_data.present? && field_data.key?(:type)
      fd = field_data.clone
      type = fd[:type]
      fd.delete(:type)
    end

    render partial: "shared/form_inputs/#{type}", locals: { form: form, field: field_name, translate_path: translate_path, options: fd, container_options: {} }
  end

  def user_profile_pages
    [:'manage-profile', :'favorite-places', :'rated-places', :'uploaded-photos']
  end

  def provider_profile_pages
    [:'manage-provider', :'manage-places', :'moderate-photos']
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
