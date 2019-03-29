//= require component/tinymce

$('#user_has_agreed').change(function() {
  var state = $(this).is(":checked")
  $('#new_user input[type="submit"]').attr('disabled', !state)
})

