class TagInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    input_html_options[:type] ||= input_type

    max_inputs = input_html_options[:'data-max'] || 3
    input_html_options.delete(:'data-max')
    ar = Array(object.public_send(attribute_name))
     Rails.logger.debug("------tag input--------------------------------------#{ar.inspect}")
    # existing_values = ar.map do |array_el|
    #   @builder.text_field(nil, input_html_options.merge(value: array_el, name: "#{object_name}[#{attribute_name}][]", id: nil))
    # end

    # if ar.length < max_inputs
    #   existing_values.push @builder.text_field(nil, input_html_options.merge(value: nil, name: "#{object_name}[#{attribute_name}][]", id: nil))
    #   if ar.length != max_inputs - 1
    #     existing_values.push "<button class='field-add'>#{t('shared.add')}</button>"
    #   end
    # end
existing_values = [ '<span> test</span>']
    template.content_tag(:div, existing_values.join.html_safe, class: 'field-tag') #, 'data-max': max_inputs
  end

  def input_type
    :text
  end
  # def input_html_classes
  #   super.push('no-spinner')
  # end
end
