/* global $ */
//= require component/rator
//= require component/recaptcha
//= require component/tinymce

pollution.components.map.init('place_map', { zoom: 16, type: 'data' })

// $('a[data-action]'
// 'data-action': true, 'data-action-id': item.id


$(document).on("click", "[data-action]", function (event) {
  console.log('clci')
  var tt = $(this)
  $.ajax({
    url: tt.attr("href"),
    dataType: 'json'
  })
  .success(function (d) {
    // console.log('success', d)
  }).error(function (e) {
    // console.log('error', e)
  }).complete(function (e,b) {
    // console.log('complete', e)
  });

  event.preventDefault();
  event.stopPropagation();
});
