module AdminHelper

  # Capitalized item name, with nil check
  def capitalized_name(name)
    result = ''
    if name
      result = name.slice(0,1).capitalize + name.slice(1..-1)
    end
    return result
  end

  def render_form_field(type, form, field_name, translate_path, options=nil)
    render partial: "shared/form_inputs/#{type}", locals: { form: form, field: field_name, translate_path: "#{translate_path}#{field_name}", options: options }
  end
  def render_form_actions
    render partial: "shared/form_actions"
  end
  def create_field_input(form, field_name, field_data, translate_path)
     # Rails.logger.debug("--------------------------------------------#{field_name} #{field_data}")
    if field_data == nil
      render partial: "shared/form_inputs/text_field", locals: { form: form, field: field_name, translate_path: translate_path }
    else
      "<span>test</span>"
    end
  end
end
