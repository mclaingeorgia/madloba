# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.error_notification_class = 'alert alert-danger'
  config.button_class = 'btn btn-default'
  config.boolean_style = :inline
  config.boolean_label_class = nil
  config.default_form_class = nil#'form-container'
  # config.collection_label_methods = [  ]
  # config.i18n_scope = 'form'
  config.wrappers :vertical_form, tag: 'div', class: 'field-wrapper', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'field-label'
    b.use :input, class: 'field-input'
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :vertical_file_input, tag: 'div', class: 'field-wrapper', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly

    b.use :label, class: 'field-label'
    b.use :input, class: 'field-input'
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :vertical_boolean, tag: 'div', class: 'field-wrapper', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly

    b.use :input, class: 'field-input'
    b.use :label, class: 'field-label'
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :vertical_checkboxes, tag: 'div', class: 'field-wrapper checkboxes', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'field-label'
    b.use :input, class: 'field-input'
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end
  config.wrappers :vertical_radios, tag: 'div', class: 'field-wrapper radios', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'field-label'
    b.use :input, class: 'field-input'
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end
  # config.wrappers :horizontal_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
  #   b.use :html5
  #   b.use :placeholder
  #   b.optional :maxlength
  #   b.optional :pattern
  #   b.optional :min_max
  #   b.optional :readonly
  #   b.use :label, class: 'col-sm-3 control-label'

  #   b.wrapper tag: 'div', class: 'col-sm-6' do |ba|
  #     ba.use :input, class: 'form-control'
  #     ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
  #     ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  #   end
  # end

  # config.wrappers :horizontal_file_input, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
  #   b.use :html5
  #   b.use :placeholder
  #   b.optional :maxlength
  #   b.optional :readonly
  #   b.use :label, class: 'col-sm-3 control-label'

  #   b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
  #     ba.use :input
  #     ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
  #     ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  #   end
  # end

  # config.wrappers :horizontal_boolean, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
  #   b.use :html5
  #   b.optional :readonly

  #   b.wrapper tag: 'div', class: 'col-sm-offset-3 col-sm-9' do |wr|
  #     wr.wrapper tag: 'div', class: 'checkbox' do |ba|
  #       ba.use :label_input
  #     end

  #     wr.use :error, wrap_with: { tag: 'span', class: 'help-block' }
  #     wr.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  #   end
  # end

  # config.wrappers :horizontal_radio_and_checkboxes, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
  #   b.use :html5
  #   b.optional :readonly

  #   b.use :label, class: 'col-sm-3 control-label'

  #   b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
  #     ba.use :input
  #     ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
  #     ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  #   end
  # end

  # config.wrappers :inline_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
  #   b.use :html5
  #   b.use :placeholder
  #   b.optional :maxlength
  #   b.optional :pattern
  #   b.optional :min_max
  #   b.optional :readonly
  #   b.use :label, class: 'sr-only'

  #   b.use :input, class: 'form-control'
  #   b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
  #   b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  # end

  config.wrappers :multi_select, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'control-label'
    b.wrapper tag: 'div', class: 'form-inline' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.label_text = lambda { |label, required, explicit_label|
    colon = ':'
    if label.end_with? '!:'
      colon = ''
      label.chomp!('!:')
    end
    "#{label}#{required}#{colon}"
  }
  config.item_wrapper_tag = :div
  config.include_default_input_wrapper_class = true
  # Wrappers for forms and inputs using the Bootstrap toolkit.
  # Check the Bootstrap docs (http://getbootstrap.com)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :vertical_form
  config.wrapper_mappings = {
    check_boxes: :vertical_checkboxes,
    radio_buttons: :vertical_radios,
    file: :vertical_file_input,
    boolean: :vertical_boolean,
    datetime: :multi_select,
    date: :multi_select,
    time: :multi_select
  }
end
