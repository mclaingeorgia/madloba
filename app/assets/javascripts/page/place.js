/* global $ */
//= require component/rator
//= require component/recaptcha
//= require component/tinymce

pollution.components.map.init('place_map', { zoom: 16, type: 'data' })

pollution.components.rator.deferred_bind($('.action-bar .rator'), function(v, $element) {
  $element.attr('href', $element.attr('data-href-template').replace(/_v_/g, v))
  xhr($element)
})

pollution.components.rator.deferred_bind($('.action-bar .favoritor'), function(v, $element) {
  $element.attr('href', $element.attr('data-href-template').replace(/_v_/g, v))
  xhr($element)
})

// var report_dialog = $('[data-bind="place_report"]')
$(document).on('click', '#place_report_send', function () {
  var v = $('#place_report_reason').val()
  if(v !== '') {
    $element = $('#place_report_link')
    $element.attr('href', $element.attr('data-href-template').replace(/_v_/g, v))
    xhr($element)
    pollution.components.dialog.close()
  }
})
