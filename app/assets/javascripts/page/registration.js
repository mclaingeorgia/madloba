//= require component/tinymce

$('#user_has_agreed').change(function() {
  var state = $(this).is(":checked")
  $('#new_user input[type="submit"]').attr('disabled', !state)
})

$('[name="user[is_service_provider]"').change(function() {
  var state = $(this).val()
  $('#new_user #user_providers').toggle(state)
})
