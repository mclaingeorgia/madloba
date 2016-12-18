global = this

global.GeneralSettings = ->
  @init()

GeneralSettings::init = ->
  # Character counter (class 'textarea_count'), for text area, in 'General settings'.
  $('.textarea_count').keyup ->
    maxlength = $(this).attr('maxlength')
    textlength = $(this).val().length
    $('.remaining_characters').html maxlength - textlength
    return

  $('.textarea_count').keydown ->
    maxlength = $(this).attr('maxlength')
    textlength = $(this).val().length
    $('.remaining_characters').html maxlength - textlength
    return

  $('.textarea_count_ka').keyup ->
    maxlength = $(this).attr('maxlength')
    textlength = $(this).val().length
    $('.remaining_characters_ka').html maxlength - textlength
    return

  $('.textarea_count_ka').keydown ->
    maxlength = $(this).attr('maxlength')
    textlength = $(this).val().length
    $('.remaining_characters_ka').html maxlength - textlength
    return
