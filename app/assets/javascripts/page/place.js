/* global $ */
//= require component/rator
//= require component/recaptcha
//= require component/tinymce

pollution.components.map.init('place_map', { zoom: 16, type: 'data' })

pollution.components.rator.bind($('.action-bar .rator'), function(v, $element) {
  console.log(v)
  $element.attr('href', $element.attr('data-href-template').replace(/_v_/g, v))
  xhr($element)
})
